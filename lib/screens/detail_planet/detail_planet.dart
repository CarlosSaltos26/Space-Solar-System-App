import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/data/models/planet_model.dart'; // Importante
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/detail_card/detail_card_planet.dart';
import 'package:space_solar_app/widgets/logotipo_bn/logotipo_bn.dart';
import 'package:space_solar_app/widgets/planet_3d_viewer/planet_3d_viewer.dart';
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

                // ZONA FIJA (fuera del scroll): el cubo 3D necesita capturar
                // sus propios gestos de arrastre (rotar) y pellizco (zoom)
                // sin que un SingleChildScrollView padre se los robe.
                // Antes había aquí una Image.asset estática del planeta.
                // Ahora Planet3DViewer dibuja el modelo 3D (flutter_cube) con
                // rotación automática y el botón para alternar real/low poly.
                //
                // NOTA: ya no envolvemos esto en un SizedBox con altura propia.
                // Planet3DViewer define su altura internamente (Cube de 800.h +
                // botón + texto "MODELO 3D"). Ponerle una altura externa distinta
                // generaba overflow porque dos restricciones competían por el
                // mismo espacio con números desincronizados.
                Planet3DViewer(planetIndex: planetIndex),

                // ZONA SCROLLEABLE: solo el contenido textual/card de abajo.
                // Esto evita el overflow sin que el cubo compita por gestos.
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 4. PASAR EL PLANETA A LA TARJETA: Enviamos el objeto al widget interno
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DetailCardPlanet(planet: planet, planetIndex: planetIndex),
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
              ],
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