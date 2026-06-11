import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:space_solar_app/data/providers/planet_provider.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/btn_explorar/boton_explorar.dart';
import 'package:space_solar_app/widgets/cinturon_asteriodes/cinturon_asteroides.dart';
import 'package:space_solar_app/widgets/cinturon_kuiper/cinturon_kuiper.dart';
import 'package:space_solar_app/widgets/cometa/cometa_widget.dart';
import 'package:space_solar_app/widgets/info_button/info_button.dart';
import 'package:space_solar_app/widgets/info_card/info_card.dart';
import 'package:space_solar_app/widgets/logo/logotipo.dart';
import 'package:space_solar_app/widgets/sistema_solar/sistema_solar.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';
import 'package:space_solar_app/widgets/sun/sun.dart';
import 'package:space_solar_app/widgets/viento_solar/viento_solar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _parallaxX = 0.0;
  double _parallaxY = 0.0;
  double _smoothX = 0.0;
  double _smoothY = 0.0;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  Timer? _smoothTimer;

  int? _cardAbierto;

  static const _infoData = [
    {
      'titulo': 'El Sol',
      'subtitulo': 'Estrella tipo G — centro del sistema solar',
      'icono': '☀️',
      'descripcion':
          'El Sol es la estrella en el centro de nuestro sistema solar. Representa el 99.86% de toda la masa del sistema solar y su energía hace posible la vida en la Tierra.',
      'datos': [
        {'label': 'Diámetro', 'valor': '1.392.000 km'},
        {'label': 'Masa', 'valor': '1.989 × 10³⁰ kg'},
        {'label': 'Temperatura', 'valor': '5.500 °C'},
        {'label': 'Edad', 'valor': '4.600 millones años'},
        {'label': 'Distancia a Tierra', 'valor': '149.6 millones km'},
        {'label': 'Tipo', 'valor': 'Enana amarilla G2V'},
      ],
    },
    {
      'titulo': 'Cinturones de Van Allen',
      'subtitulo': 'Zona de radiación intensa',
      'icono': '⚡',
      'descripcion':
          'Son dos zonas de plasma y partículas cargadas atrapadas por el campo magnético de la Tierra. Descubiertos en 1958 por James Van Allen, protegen la Tierra del viento solar.',
      'datos': [
        {'label': 'Capa interna', 'valor': '1.000 – 6.000 km'},
        {'label': 'Capa externa', 'valor': '13.000 – 60.000 km'},
        {'label': 'Descubrimiento', 'valor': '1958'},
        {'label': 'Partículas', 'valor': 'Protones y electrones'},
        {'label': 'Origen', 'valor': 'Viento solar'},
        {'label': 'Forma', 'valor': 'Toroidal'},
      ],
    },
    {
      'titulo': 'Cinturón de Asteroides',
      'subtitulo': 'Entre Marte y Júpiter',
      'icono': '🪨',
      'descripcion':
          'Región del sistema solar entre las órbitas de Marte y Júpiter. Contiene millones de asteroides y planetas enanos como Ceres, restos de la formación del sistema solar.',
      'datos': [
        {'label': 'Distancia al Sol', 'valor': '2.2 – 3.2 UA'},
        {'label': 'Objetos', 'valor': '+1.1 millones'},
        {'label': 'Masa total', 'valor': '4% de la Luna'},
        {'label': 'Planeta enano', 'valor': 'Ceres'},
        {'label': 'Ancho', 'valor': '~1 UA'},
        {'label': 'Origen', 'valor': 'Formación solar'},
      ],
    },
    {
      'titulo': 'Cinturón de Kuiper',
      'subtitulo': 'Más allá de Neptuno',
      'icono': '🌌',
      'descripcion':
          'Región del sistema solar más allá de Neptuno. Similar al cinturón de asteroides pero 20 veces más ancho. Contiene objetos helados como Plutón, Eris y Makemake.',
      'datos': [
        {'label': 'Distancia al Sol', 'valor': '30 – 50 UA'},
        {'label': 'Ancho', 'valor': '20 UA'},
        {'label': 'Objetos conocidos', 'valor': '+2.000'},
        {'label': 'Plutón', 'valor': '39.5 UA'},
        {'label': 'Temperatura', 'valor': '-220 °C'},
        {'label': 'Composición', 'valor': 'Hielo y roca'},
      ],
    },
    {
      'titulo': 'Sistema Solar',
      'subtitulo': 'Brazo de Orión — Vía Láctea',
      'icono': '🌠',
      'descripcion':
          'Nuestro sistema solar tiene 4.600 millones de años. Está formado por el Sol, 8 planetas, 5 planetas enanos, cientos de lunas, millones de asteroides y cometas.',
      'datos': [
        {'label': 'Edad', 'valor': '4.600 millones años'},
        {'label': 'Planetas', 'valor': '8'},
        {'label': 'Planetas enanos', 'valor': '5 oficiales'},
        {'label': 'Diámetro', 'valor': '~2 años luz'},
        {'label': 'Galaxia', 'valor': 'Vía Láctea'},
        {'label': 'Velocidad orbital', 'valor': '220 km/s'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initSensors();
    _initSmoothTimer();
    _fetchPlanets();
  }

  void _fetchPlanets() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<PlanetProvider>(context, listen: false);
      await provider.fetchPlanets();
    });
  }

  void _initSensors() {
    _accelSubscription =
        accelerometerEventStream(
          samplingPeriod: SensorInterval.gameInterval,
        ).listen((AccelerometerEvent event) {
          _parallaxX = (-event.x * 0.8).clamp(-6.0, 6.0);
          _parallaxY = (-event.y * 0.8).clamp(-6.0, 6.0);
        });
  }

  void _initSmoothTimer() {
    _smoothTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      final newX = _smoothX + (_parallaxX - _smoothX) * 0.05;
      final newY = _smoothY + (_parallaxY - _smoothY) * 0.05;
      if ((newX - _smoothX).abs() > 0.01 || (newY - _smoothY).abs() > 0.01) {
        setState(() {
          _smoothX = newX;
          _smoothY = newY;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _smoothTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ← Aquí sí se puede usar context
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundGradient(),

          Transform.translate(
            offset: Offset(_smoothX * 1.0, _smoothY * 1.0),
            child: StarField(),
          ),

          CinturonAsteroides(),
          CinturonKuiper(),
          VientoSolar(),
          SistemaSolar(),

          Center(child: Sun()),

          CometaWidget(),
          Logotipo(),
          BotonExplorar(),

          // ── Botones de información ───────────────────
          Positioned(
            left: screenW * 0.50,
            top: screenH * 0.50,
            child: InfoButton(onTap: () => setState(() => _cardAbierto = 1)),
          ),
          Positioned(
            left: screenW * 0.46,
            top: screenH * 0.60,
            child: InfoButton(onTap: () => setState(() => _cardAbierto = 2)),
          ),
          Positioned(
            left: screenW * 0.42,
            top: screenH * 0.72,
            child: InfoButton(onTap: () => setState(() => _cardAbierto = 3)),
          ),
          Positioned(
            left: screenW * 0.08,
            top: screenH * 0.28,
            child: InfoButton(onTap: () => setState(() => _cardAbierto = 4)),
          ),
          Positioned(
            left: screenW * 0.78,
            top: screenH * 0.26,
            child: InfoButton(onTap: () => setState(() => _cardAbierto = 5)),
          ),

          // ── Card glassmorphism ───────────────────────
          if (_cardAbierto != null)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 250),
                child: InfoCard(
                  titulo: _infoData[_cardAbierto! - 1]['titulo'] as String,
                  subtitulo: _infoData[_cardAbierto! - 1]['subtitulo'] as String,
                  icono: _infoData[_cardAbierto! - 1]['icono'] as String,
                  descripcion:
                      _infoData[_cardAbierto! - 1]['descripcion'] as String,
                  datos: (_infoData[_cardAbierto! - 1]['datos'] as List)
                      .cast<Map<String, String>>(),
                  onCerrar: () => setState(() => _cardAbierto = null),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
