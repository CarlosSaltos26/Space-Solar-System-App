import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CometaWidget extends StatefulWidget {
  const CometaWidget({super.key});

  @override
  State<CometaWidget> createState() => _CometaWidgetState();
}

class _CometaWidgetState extends State<CometaWidget>
    with TickerProviderStateMixin {

  final List<_CometaData> _cometas = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _scheduleNextCometa();
  }

  void _scheduleNextCometa() {
    final segundos = 8 + _rng.nextInt(8);
    Future.delayed(Duration(seconds: segundos), () {
      if (!mounted) return;
      _lanzarCometa();
      _scheduleNextCometa();
    });
  }

  void _lanzarCometa() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    final direccion = _rng.nextInt(4);

    final cometa = _CometaData(
      controller: controller,
      direccion: direccion,
      grosorCola: 2.0 + _rng.nextDouble() * 2.0,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => _cometas.remove(cometa));
        }
        controller.dispose();
      }
    });

    setState(() => _cometas.add(cometa));
    controller.forward();
  }

  @override
  void dispose() {
    for (final c in _cometas) {
      c.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _cometas.map((cometa) {
        return AnimatedBuilder(
          animation: cometa.controller,
          builder: (_, _) => CustomPaint(
            painter: _CometaPainter(
              progreso: cometa.controller.value,
              direccion: cometa.direccion,
              grosorCola: cometa.grosorCola,
            ),
            size: Size.infinite,
          ),
        );
      }).toList(),
    );
  }
}

class _CometaData {
  final AnimationController controller;
  final int direccion;
  final double grosorCola;

  _CometaData({
    required this.controller,
    required this.direccion,
    required this.grosorCola,
  });
}

class _CometaPainter extends CustomPainter {
  final double progreso;
  final int direccion;
  final double grosorCola;

  static const double _longCola = 120.0;
  static const double _radioNucleo = 3.5;

  _CometaPainter({
    required this.progreso,
    required this.direccion,
    required this.grosorCola,
  });

  Offset _nucleoPos(Size size) {
    switch (direccion) {
      case 0: // top-left → bottom-right
        return Offset(
          -_longCola + (size.width + _longCola * 2) * progreso,
          size.height * 0.2 + size.height * 0.3 * progreso,
        );
      case 1: // top-right → bottom-left
        return Offset(
          size.width + _longCola - (size.width + _longCola * 2) * progreso,
          size.height * 0.15 + size.height * 0.35 * progreso,
        );
      case 2: // izquierda → derecha
        return Offset(
          -_longCola + (size.width + _longCola * 2) * progreso,
          size.height * 0.25,
        );
      case 3: // derecha → izquierda
        return Offset(
          size.width + _longCola - (size.width + _longCola * 2) * progreso,
          size.height * 0.35,
        );
      default:
        return Offset.zero;
    }
  }

  double _angulo() {
    switch (direccion) {
      case 0: return math.atan2(0.3, 1.0);
      case 1: return math.pi - math.atan2(0.35, 1.0);
      case 2: return 0.0;
      case 3: return math.pi;
      default: return 0.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final nucleo = _nucleoPos(size);
    final angulo = _angulo();

    final opacidad = progreso < 0.1
        ? progreso / 0.1
        : progreso > 0.85
            ? (1.0 - progreso) / 0.15
            : 1.0;

    final colaDir = Offset(
      -math.cos(angulo),
      -math.sin(angulo),
    );

    final colaFin = nucleo + colaDir * _longCola;
    final perp = Offset(-colaDir.dy, colaDir.dx);

    final path = Path()
      ..moveTo(nucleo.dx, nucleo.dy)
      ..lineTo(
        colaFin.dx + perp.dx * grosorCola,
        colaFin.dy + perp.dy * grosorCola,
      )
      ..lineTo(
        colaFin.dx - perp.dx * grosorCola,
        colaFin.dy - perp.dy * grosorCola,
      )
      ..close();

    final paintCola = Paint()
      ..shader = ui.Gradient.linear(
        nucleo,
        colaFin,
        [
          Colors.white.withValues(alpha: 0.4 * opacidad),
          Colors.lightBlueAccent.withValues(alpha: 0.15 * opacidad),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paintCola);

    // Glow del núcleo
    final paintGlow = Paint()
      ..color = Colors.white.withValues(alpha: opacidad)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    canvas.drawCircle(nucleo, _radioNucleo, paintGlow);

    // Núcleo sólido
    canvas.drawCircle(
      nucleo,
      _radioNucleo * 0.5,
      Paint()..color = Colors.white.withValues(alpha: opacidad),
    );
  }

  @override
  bool shouldRepaint(_CometaPainter old) => old.progreso != progreso;
}