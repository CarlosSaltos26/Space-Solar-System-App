import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class VientoSolar extends StatefulWidget {
  const VientoSolar({super.key});

  @override
  State<VientoSolar> createState() => _VientoSolarState();
}

class _VientoSolarState extends State<VientoSolar>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  double _tiempo = 0.0;

  // Datos de cada partícula generados una sola vez en el State
  static const int _total = 80;
  late final List<double> _angulos;
  late final List<double> _velocidades;
  late final List<double> _faseInicial; // offset de fase para que no arranquen todas juntas
  late final List<double> _longitud;    // qué tan lejos viaja cada partícula
  late final List<double> _grosor;

  @override
  void initState() {
    super.initState();

    final rng = math.Random(77);
    _angulos      = List.generate(_total, (_) => rng.nextDouble() * 2 * math.pi);
    _velocidades  = List.generate(_total, (_) => 0.4 + rng.nextDouble() * 0.4);
    _faseInicial  = List.generate(_total, (_) => rng.nextDouble()); // 0.0 a 1.0
    _longitud     = List.generate(_total, (_) => 30.0 + rng.nextDouble() * 300.0);
    _grosor       = List.generate(_total, (_) => 0.4 + rng.nextDouble() * 0.6);

    _stopwatch.start();
    _ticker = createTicker((_) {
      final t = _stopwatch.elapsedTicks / _stopwatch.frequency;
      if (mounted) setState(() => _tiempo = t);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 600,
        child: CustomPaint(
          painter: _VientoSolarPainter(
            tiempo: _tiempo,
            angulos: _angulos,
            velocidades: _velocidades,
            faseInicial: _faseInicial,
            longitud: _longitud,
            grosor: _grosor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _VientoSolarPainter extends CustomPainter {
  final double tiempo;
  final List<double> angulos;
  final List<double> velocidades;
  final List<double> faseInicial;
  final List<double> longitud;
  final List<double> grosor;

  _VientoSolarPainter({
    required this.tiempo,
    required this.angulos,
    required this.velocidades,
    required this.faseInicial,
    required this.longitud,
    required this.grosor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Radio del sol — las partículas nacen justo en su borde
    const radioSol = 18.0;

    for (int i = 0; i < angulos.length; i++) {
      // Fase cíclica 0.0 → 1.0 → 0.0 → ... cada partícula en su propio ciclo
      final fase = ((tiempo * velocidades[i] * 0.3) + faseInicial[i]) % 1.0;

      // Distancia desde el centro: empieza en el borde del sol, viaja hacia afuera
      final distancia = radioSol + fase * longitud[i];

      // Posición actual
      final x = cx + distancia * math.cos(angulos[i]);
      final y = cy + distancia * math.sin(angulos[i]);

      // Opacidad: aparece al salir del sol, se desvanece al alejarse
      final opacidad = fase < 0.2
          ? fase / 0.2              // fade in rápido
          : (1.0 - fase) * 0.18;   // fade out largo y suave — muy sutil

      if (opacidad <= 0) continue;

      final paint = Paint()
        ..color = const Color(0xFFFFA040).withValues(alpha: opacidad)
        ..strokeWidth = grosor[i]
        ..style = PaintingStyle.stroke;

      // Dibujamos una línea corta en la dirección de movimiento
      final dx = math.cos(angulos[i]) * 3.0;
      final dy = math.sin(angulos[i]) * 3.0;

      canvas.drawLine(
        Offset(x - dx, y - dy),
        Offset(x + dx, y + dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_VientoSolarPainter old) => old.tiempo != tiempo;
}