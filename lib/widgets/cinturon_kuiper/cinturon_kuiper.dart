import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CinturonKuiper extends StatefulWidget {
  const CinturonKuiper({super.key});

  @override
  State<CinturonKuiper> createState() => _CinturonKuiperState();
}

class _CinturonKuiperState extends State<CinturonKuiper>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  double _tiempo = 0.0;

  // Generamos los datos UNA sola vez aquí en el State, no en el Painter
  late final List<double> _angulos;
  late final List<double> _velocidades;
  late final List<double> _jitter;
  late final List<double> _tamanios;
  late final List<Color> _colores;
  late final List<double> _opacidades;

  static const int _total = 150;

  @override
  void initState() {
    super.initState();

    final rng = math.Random(149);
    _angulos     = List.generate(_total, (_) => rng.nextDouble() * 2 * math.pi);
    _velocidades = List.generate(_total, (_) => 0.018 + rng.nextDouble() * 0.008);
    _jitter      = List.generate(_total, (_) => 1.0 + (rng.nextDouble() - 0.5) * 0.18);
    _tamanios    = List.generate(_total, (_) => 1.0 + rng.nextDouble() * 1.8);
    _colores     = List.generate(_total, (_) {
      switch (rng.nextInt(3)) {
        case 0:  return const Color(0xFFE8A882);
        case 1:  return const Color(0xFFAAC4E0);
        default: return const Color(0xFFDDDDDD);
      }
    });
    _opacidades = List.generate(_total, (_) => 0.25 + rng.nextDouble() * 0.35);

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
          painter: _KuiperPainter(
            tiempo: _tiempo,
            angulos: _angulos,
            velocidades: _velocidades,
            jitter: _jitter,
            tamanios: _tamanios,
            colores: _colores,
            opacidades: _opacidades,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _KuiperPainter extends CustomPainter {
  final double tiempo;
  final List<double> angulos;
  final List<double> velocidades;
  final List<double> jitter;
  final List<double> tamanios;
  final List<Color> colores;
  final List<double> opacidades;

  _KuiperPainter({
    required this.tiempo,
    required this.angulos,
    required this.velocidades,
    required this.jitter,
    required this.tamanios,
    required this.colores,
    required this.opacidades,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    const baseRadioX = 168.0;
    const baseRadioY = 168.0 * 2.15;

    for (int i = 0; i < angulos.length; i++) {
      final t = angulos[i] + tiempo * velocidades[i] * 0.15;
      final rx = baseRadioX * jitter[i];
      final ry = baseRadioY * jitter[i];

      final x = cx + rx * math.cos(t);
      final y = cy + ry * math.sin(t);

      final paint = Paint()
        ..color = colores[i].withValues(alpha: opacidades[i]);
        //..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8);

      canvas.drawCircle(Offset(x, y), tamanios[i], paint);
    }
  }

  @override
  bool shouldRepaint(_KuiperPainter old) => old.tiempo != tiempo;
}