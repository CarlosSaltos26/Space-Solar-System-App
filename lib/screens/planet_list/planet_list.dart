import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/lista_planetas/lista_planetas.dart';
import 'package:space_solar_app/widgets/logo/logotipo.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';

class PlanetList extends StatefulWidget {
  const PlanetList({super.key});

  @override
  State<PlanetList> createState() => _PlanetListState();
}

class _PlanetListState extends State<PlanetList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //fondo degradado
            BackgroundGradient(),
            //Fondo de estrellas
            StarField(),
            //logotipo superior con padding
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //logotipo en la parte superior
                  Logotipo(),

                  //separacion de 20 px
                  SizedBox(height: 20),

                  //Texto Planetas
                  Text(
                    "PLANETAS DEL SISTEMA SOLAR",
                    style: TextStyle(fontSize: 55.sp),
                  ),

                  //separacion de 20 px
                  SizedBox(height: 20),

                  //Lista de planetas
                  Expanded(child: ListaPlanetas()),

                  //Ahora ponermos el boton de la parte inferior

                  // Botón posicionado en la base
                  Positioned(
                    bottom: 20.h, // Distancia exacta desde el borde inferior
                    left:
                        24.w, // Márgenes laterales para que se estire o centre
                    right: 24.w,
                    child: SafeArea(
                      child: ElevatedButton(
                        onPressed: () {
                          //print('Botón presionado');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/icono.png',
                              width: 24,
                              height: 24,
                            ),

                            SizedBox(width: 10),

                            Text('Ingresar'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
