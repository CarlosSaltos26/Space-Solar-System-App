import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class StarField extends StatefulWidget {
  const StarField({super.key});

  @override
  State<StarField> createState() => _StarFieldState();
}

// Añadimos SingleTickerProviderStateMixin para poder usar animaciones
class _StarFieldState extends State<StarField> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> _starPoints = [];
  List<double> _starOffsets = []; // Para que cada estrella parpadee en momentos distintos

  @override
  void initState() {
    super.initState();
    // Configuramos el controlador para que sea infinito
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Velocidad del ciclo de parpadeo
    )..repeat(); // .repeat() hace que vaya de 0 a 1 constantemente
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_starPoints.isEmpty) {
      final size = MediaQuery.of(context).size;
      final random = Random();
      _starPoints = List.generate(250, (index) {
        return Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
      });
      // Generamos un desfase aleatorio para cada estrella
      _starOffsets = List.generate(250, (index) => random.nextDouble() * pi * 2);
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos AnimatedBuilder para que el CustomPaint se redibuje con la animación
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: StarPainter(
            points: _starPoints,
            animationValue: _controller.value,
            offsets: _starOffsets,
          ),
        );
      },
    );
  }
}

class StarPainter extends CustomPainter {
  final List<Offset> points;
  final List<double> offsets;
  final double animationValue;

  StarPainter({
    required this.points,
    required this.animationValue,
    required this.offsets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Usamos .length en lugar de .size
    for (int i = 0; i < points.length; i++) {
      
      // Calculamos la opacidad con la función seno (importada de dart:math)
      // El abs() es para que siempre sea positiva
      double opacity = 0.3 + (0.7 * sin(animationValue * 2 * pi + offsets[i]).abs());
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..strokeWidth = i % 10 == 0 ? 2.5 : 1.5 // Algunas más grandes para variedad
        ..strokeCap = StrokeCap.round;

      // Dibujamos cada estrella individualmente para que tenga su propia opacidad
      canvas.drawPoints(ui.PointMode.points, [points[i]], paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}