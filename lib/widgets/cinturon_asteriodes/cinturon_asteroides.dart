import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class CinturonAsteroides extends StatefulWidget {
  const CinturonAsteroides({super.key});

  @override
  State<CinturonAsteroides> createState() => _CinturonAsteroidesState();
}

class _CinturonAsteroidesState extends State<CinturonAsteroides>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  ui.Image? _image;
  double _tiempo = 0.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _stopwatch.start();
    _ticker = createTicker((_) {
      final t = _stopwatch.elapsedTicks / _stopwatch.frequency;
      if (mounted) setState(() => _tiempo = t);
    })..start();
  }

  Future<void> _loadImage() async {
    final data = await rootBundle.load('assets/asteroides/asteroide.png');
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 8,
      targetHeight: 8,
    );
    final frame = await codec.getNextFrame();
    if (mounted) setState(() => _image = frame.image);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox.shrink();

    return Center(
      child: SizedBox(
        width: 350,
        height: 600,
        child: CustomPaint(
          painter: _CinturonPainter(tiempo: _tiempo, image: _image!),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _CinturonPainter extends CustomPainter {
  final double tiempo;
  final ui.Image image;

  // Seed fijo = siempre el mismo patrón, sin recalcular cada frame
  static final _rng = math.Random(42);
  static final List<double> _angulosBase = List.generate(
    40, (_) => _rng.nextDouble() * 2 * math.pi,
  );
  static final List<double> _velocidades = List.generate(
    40, (_) => 0.10 + _rng.nextDouble() * 0.02,
  );
  static final List<double> _jitter = List.generate(
    40, (_) => 1.0 + (_rng.nextDouble() - 0.2) * 0.15,
  );
  static final List<double> _escala = List.generate(
    40, (_) => 0.5 + _rng.nextDouble() * 0.2,
  );

  _CinturonPainter({required this.tiempo, required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Mismo sistema de coordenadas que SistemaSolar:
    // entre Marte (radio 105) y Júpiter (radio 115) pero con ratio elíptico
    const baseRadioX = 110.0;
    const baseRadioY = 110.0 * 1.7; // mismo ratio aprox de esas órbitas

    final paint = Paint()..filterQuality = FilterQuality.low;
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    for (int i = 0; i < 40; i++) {
      final t = (_angulosBase[i] + tiempo * _velocidades[i] * 0.15);
      final rx = baseRadioX * _jitter[i];
      final ry = baseRadioY * _jitter[i];

      final x = cx + rx * math.cos(t);
      final y = cy + ry * math.sin(t);
      final s = _escala[i];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t); // rota con la órbita
      canvas.scale(s);
      canvas.drawImage(image, Offset(-imgW / 2, -imgH / 2), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CinturonPainter old) => old.tiempo != tiempo;
}