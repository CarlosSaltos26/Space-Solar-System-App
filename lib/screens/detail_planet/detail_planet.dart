import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/data/models/planet_model.dart'; // Importante
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/detail_card/detail_card_planet.dart';
import 'package:space_solar_app/widgets/logotipo_bn/logotipo_bn.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';

class DetailPlanet extends StatelessWidget {
  // 1. Declaramos la variable del modelo que va a recibir
  final PlanetModel planet;
  final int planetIndex;

  // Mapa local solo para asociar los assets visuales usando el 'id' de la API como clave
    final List<String> planetAssets = [
      'assets/planetas/mercurio.png',
      'assets/planetas/venus.png',
      'assets/planetas/tierra.png',
      'assets/planetas/marte.png',
      'assets/planetas/jupiter.png',
      'assets/planetas/saturno.png',
      'assets/planetas/urano.png',
      'assets/planetas/neptuno.png'
    ];

    final List<String> nombrePlanetaEsp = [
        'Mercurio',
        'Venus',
        'Tierra',
        'Marte',
        'Jupiter',
        'Saturno',
        'Urano',
        'Neptuno'
    ];
      

  // 2. Lo agregamos obligatoriamente al constructor
   DetailPlanet({super.key, required this.planet,required this.planetIndex,});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGradient(),
          const StarField(),
          Container(
            width: double.infinity,
            height: 700.h, 
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF5a237d),
                  const Color(0xFF2b052e).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h), 
                  
                  // 3. NOMBRE DINÁMICO: Cambiamos 'MERCURIO' fijo por el dato del modelo
                  Text(
                    nombrePlanetaEsp[planetIndex].toUpperCase(),
                    style: TextStyle(
                      fontSize: 100.sp, 
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      letterSpacing: 2.0,
                    ),
                  ),

                  Center(
                    child: SizedBox(
                      width: 1000.w, 
                      height: 800.h, // Ajusté este valor que tenía un typo en tu original (100032.h)
                      child: Image.asset(
                        // Aquí puedes implementar una lógica idéntica para renderizar el asset correcto
                        planetAssets[planetIndex],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 4. PASAR EL PLANETA A LA TARJETA: Enviamos el objeto al widget interno
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DetailCardPlanet(planet: planet, planetIndex: planetIndex,), 
                  ),

                  SizedBox(height: 10.h),
                  const Center(
                    child: SizedBox(
                      width: 280, 
                      child: LogotipoBn(),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60.h, 
            left: 30.w,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orange, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}