import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';

class SistemaSolar extends StatefulWidget {
  const SistemaSolar({super.key});

  @override
  State<SistemaSolar> createState() => _SistemaSolarState();
}

class _SistemaSolarState extends State<SistemaSolar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Stopwatch _stopwatch = Stopwatch();

  // ESTRUCTURA ACTUALIZADA: Añadimos la propiedad opcional 'lunas' a los planetas
  final List<Map<String, dynamic>> planetasData = [
    {'nombre': 'mercurio', 'radio': 50.0,  'ratio': 1.2, 'vel': 1.3, 'tam': 20.0, 'anguloInicial': 0.5, 'asset': 'assets/planetas/mercurio.png'},
    {'nombre': 'venus',    'radio': 65.0,  'ratio': 1.2, 'vel': 1.1, 'tam': 22.0, 'anguloInicial': 1.8, 'asset': 'assets/planetas/venus.png'},
    {
      'nombre': 'tierra',   
      'radio': 85.0,  
      'ratio': 1.4, 
      'vel': 0.9, 
      'tam': 28.0, 
      'anguloInicial': 3.2, 
      'asset': 'assets/planetas/tierra.png',
      // Agregamos su satélite natural
      'lunas': [
        {'nombre': 'luna', 'radio': 16.0, 'ratio': 1.1, 'vel': 4.0, 'tam': 6.0, 'anguloInicial': 0.0, 'asset': 'assets/planetas/luna.png'}
      ]
    },
    {'nombre': 'marte',    'radio': 105.0, 'ratio': 1.6, 'vel': 0.8, 'tam': 25.0, 'anguloInicial': 4.5, 'asset': 'assets/planetas/marte.png'},
    {
      'nombre': 'jupiter',  
      'radio': 115.0, 
      'ratio': 1.8, 
      'vel': 0.7, 
      'tam': 25.0, 
      'anguloInicial': 2.1, 
      'asset': 'assets/planetas/jupiter.png',
      // Júpiter tiene muchas lunas, ponemos 2 de ejemplo esparcidas
      'lunas': [
        {'nombre': 'io',     'radio': 14.0, 'ratio': 1.2, 'vel': 5.0, 'tam': 5.0, 'anguloInicial': 1.0, 'asset': 'assets/planetas/luna.png'},
        {'nombre': 'europa', 'radio': 19.0, 'ratio': 1.2, 'vel': 3.5, 'tam': 4.5, 'anguloInicial': 3.5, 'asset': 'assets/planetas/luna.png'}
      ]
    },
    {
      'nombre': 'saturno',  
      'radio': 125.0, 
      'ratio': 1.9, 
      'vel': 0.6, 
      'tam': 80.0, 
      'anguloInicial': 5.8, 
      'asset': 'assets/planetas/saturno.png',
      'lunas': [
        {'nombre': 'titan', 'radio': 22.0, 'ratio': 1.3, 'vel': 3.0, 'tam': 7.0, 'anguloInicial': 0.0, 'asset': 'assets/planetas/luna.png'}
      ]
    },
    {'nombre': 'urano',    'radio': 135.0, 'ratio': 2.0, 'vel': 0.5, 'tam': 35.0, 'anguloInicial': 0.9, 'asset': 'assets/planetas/urano.png'},
    {'nombre': 'neptuno',  'radio': 150.0, 'ratio': 2.1, 'vel': 0.4, 'tam': 35.0, 'anguloInicial': 3.9, 'asset': 'assets/planetas/neptuno.png'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    double escalaGlobal = Responsive.screenWidth / 380.0; 

    return Center( 
      child: Transform.scale(
        scale: escalaGlobal,
        child: SizedBox(
          width: 350, 
          height: 600,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double tiempoTotal = _stopwatch.elapsedTicks / _stopwatch.frequency;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Órbitas de los planetas
                  CustomPaint(
                    size: Size.infinite,
                    painter: OrbitasPainter(planetasData),
                  ),
                  
                  // Renderizado de planetas (y sus lunas internamente)
                  ...planetasData.map((data) {
                    return Planeta(
                      radioX: data['radio'],
                      radioY: data['radio'] * data['ratio'],
                      velocidad: data['vel'],
                      tiempo: tiempoTotal,
                      anguloInicial: data['anguloInicial'],
                      assetPath: data['asset'],
                      tamano: data['tam'],
                      lunas: data['lunas'], // Pasamos la lista de lunas (puede ser null)
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Planeta extends StatelessWidget {
  final double radioX;
  final double radioY;
  final double velocidad;
  final double tiempo;
  final double anguloInicial;
  final String assetPath;
  final double tamano;
  final List<dynamic>? lunas; // Recibimos las lunas opcionales

  const Planeta({super.key, 
    required this.radioX, 
    required this.radioY, 
    required this.velocidad, 
    required this.tiempo, 
    required this.anguloInicial,
    required this.assetPath, 
    required this.tamano,
    this.lunas,
  });

  @override
  Widget build(BuildContext context) {
    // Posición del planeta respecto al Sol (Centro de la pantalla)
    double t = (tiempo * velocidad * 0.15) + anguloInicial;
    double x = radioX * math.cos(t);
    double y = radioY * math.sin(t);

    return Transform.translate(
      offset: Offset(x, y),
      // Usamos un Stack sin límites (clipBehavior: Clip.none) para que las lunas 
      // puedan orbitar por fuera del tamaño del contenedor del planeta padre.
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, 
        children: [
          // 1. Dibujamos el planeta en el centro
          Image.asset(assetPath, width: tamano, height: tamano),

          // 2. Si el planeta tiene lunas, las dibujamos e iteramos sobre ellas
          if (lunas != null)
            ...lunas!.map((lunaData) {
              // La luna usa el mismo 'tiempoTotal' continuo, pero con su propia velocidad (suele ser más rápida)
              double tLuna = (tiempo * lunaData['vel'] * 0.15) + lunaData['anguloInicial'];
              
              // Ecuación elíptica de la luna alrededor de su planeta
              double lunaX = lunaData['radio'] * math.cos(tLuna);
              double lunaY = (lunaData['radio'] * lunaData['ratio']) * math.sin(tLuna);

              return Transform.translate(
                offset: Offset(lunaX, lunaY),
                child: Image.asset(
                  lunaData['asset'], 
                  width: lunaData['tam'], 
                  height: lunaData['tam']
                ),
              );
            }),
        ],
      ),
    );
  }
}

class OrbitasPainter extends CustomPainter {
  final List<Map<String, dynamic>> planetas;
  OrbitasPainter(this.planetas);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final centro = size.center(Offset.zero);

    for (var p in planetas) {
      double rX = p['radio'];
      double rY = rX * p['ratio'];
      
      Rect rect = Rect.fromLTRB(centro.dx - rX, centro.dy - rY, centro.dx + rX, centro.dy + rY);
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}