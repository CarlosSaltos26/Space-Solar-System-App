import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/detail_card/detail_card_planet.dart';
import 'package:space_solar_app/widgets/logotipo_bn/logotipo_bn.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';

class DetailPlanet extends StatelessWidget {
  const DetailPlanet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fondo base de estrellas y espacio
          const BackgroundGradient(),
          const StarField(),

          // 2. EL DEGRADADO MORADO (Capa superior fija)
          Container(
            width: double.infinity,
            height: 700.h, // Ajustado proporcionalmente
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

          // 3. CONTENIDO CON SCROLL
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                  ), // Espacio superior para no chocar con el botón
                  // Nombre del Planeta (Reducido sutilmente para optimizar espacio vertical)
                  Text(
                    'MERCURIO',
                    style: TextStyle(
                      fontSize: 100
                          .sp, // De 130.sp a 110.sp para ganar espacio vertical
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      letterSpacing: 2.0,
                    ),
                  ),

                  // Planeta (Se bajó la altura fija de 850.h a 500.h para que suba la tarjeta)
                  Center(
                    child: SizedBox(
                      width: 1000.w, // <-- Cambiado de 900.w a 1170.w (+30%)
                      height: 100032.h, // <-- Cambiado de 850.h a 1100.h (+30%)
                      child: Image.asset(
                        'assets/planetas/mercurio.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Tarjeta de información (Ancho al 90%)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child:
                        DetailCardPlanet(), // Al renderizarse llamará al nuevo diseño con el resumen y bordes
                  ),

                  

                  SizedBox(height: 10.h),

                  // Logotipo en la parte inferior (Escalado sutilmente para que quepa perfecto)
                  const Center(
                    child: SizedBox(
                      width:
                          280, // Controlamos el ancho máximo formal del logo inferior
                      child: LogotipoBn(),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),

          // Botón de regreso
          Positioned(
            top: 60.h, // Bajado sutilmente para diseño responsive estándar
            left: 30.w,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.orange,
                size: 35,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
