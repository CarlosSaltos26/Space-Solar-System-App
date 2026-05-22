import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedStarField extends StatefulWidget {
  const AnimatedStarField({super.key});

  @override
  State<AnimatedStarField> createState() => _AnimatedStarFieldState();
}

class _AnimatedStarFieldState extends State<AnimatedStarField> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> _starsBack = [];
  List<Offset> _starsFront = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50), // Tiempo de la vuelta completa
    )..repeat(); // Hace que la animación sea infinita
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_starsBack.isEmpty) {
      final size = MediaQuery.of(context).size;
      // Generamos 100 estrellas para el fondo y 50 para el frente
      _starsBack = List.generate(100, (_) => Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height));
      _starsFront = List.generate(50, (_) => Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: StarFieldPainter(
            starsBack: _starsBack,
            starsFront: _starsFront,
            progress: _controller.value, // Valor de 0.0 a 1.0
          ),
        );
      },
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final List<Offset> starsBack;
  final List<Offset> starsFront;
  final double progress;

  StarFieldPainter({required this.starsBack, required this.starsFront, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBack = Paint()..color = Colors.white.withValues(alpha: 0.4);
    final paintFront = Paint()..color = Colors.white.withValues(alpha: 0.6);

    // Dibujar fondo (Lento)
    for (var star in starsBack) {
      double yPos = (star.dy + (progress * size.height * 0.5)) % size.height;
      canvas.drawCircle(Offset(star.dx, yPos), 0.8, paintBack);
    }

    // Dibujar frente (Rápido + Titileo)
    for (var star in starsFront) {
      double yPos = (star.dy + (progress * size.height)) % size.height;
      // El titileo se logra con una función seno basada en el progreso
      double opacity = 0.2 + (0.6 * sin(progress * 2 * pi * 5 + star.dx).abs());
      canvas.drawCircle(
        Offset(star.dx, yPos), 
        //aqui cambio el tama;o de las estrellas del frente
        1, 
        paintFront..color = Colors.white.withValues(alpha: opacity)
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // Necesario para animar
}