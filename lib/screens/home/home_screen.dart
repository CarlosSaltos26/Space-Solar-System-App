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
  
  // Offset actual del parallax
  double _parallaxX = 0.0;
  double _parallaxY = 0.0;

  // Para suavizar el movimiento
  double _smoothX = 0.0;
  double _smoothY = 0.0;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  Timer? _smoothTimer;

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
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval, // ~50ms, no es agresivo
    ).listen((AccelerometerEvent event) {
      // Invertimos el signo para que el movimiento sea natural
      // Clamp para no salirse de rango si el usuario sacude el teléfono
      _parallaxX = (-event.x * 1.2).clamp(-12.0, 12.0);
      _parallaxY = (-event.y * 1.2).clamp(-12.0, 12.0);
    });
  }

  void _initSmoothTimer() {
    // Interpolamos hacia el target cada 16ms (~60fps) para suavizar
    _smoothTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted) return;
      
      final newX = _smoothX + (_parallaxX - _smoothX) * 0.1;
      final newY = _smoothY + (_parallaxY - _smoothY) * 0.1;

      // Solo hacemos setState si el cambio es perceptible
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
    return Scaffold(
      body: Stack(
        children: [
          // Capa 1: fondo estático
          BackgroundGradient(),

          // Capa 2: estrellas — se mueven POCO (factor 1.0x)
          Transform.translate(
            offset: Offset(_smoothX * 1.0, _smoothY * 1.0),
            child: StarField(),
          ),

          CinturonAsteroides(),

          CinturonKuiper(),

          VientoSolar(),

          // Capa 3: sistema solar — NO se mueve (ancla visual)
          SistemaSolar(),

          //IconButton(onPressed: (){}, icon: Icon(Icons.ac_unit)),

          // Esto da sensación de que el sol está "más cerca" que las estrellas
          Transform.translate(
            offset: Offset(_smoothX * 0.4, _smoothY * 0.4),
            child: Center(child: Sun()),
          ),
          
          // Capa 5: UI estática (no se mueve nunca)
          CometaWidget(),
          Logotipo(),
          BotonExplorar(),
        ],
      ),
    );
  }
}