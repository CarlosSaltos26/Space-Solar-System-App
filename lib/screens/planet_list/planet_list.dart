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
                  SizedBox(height: 20,),

                  //Texto Planetas
                  Text("PLANETAS DEL SISTEMA SOLAR",
                  style: TextStyle(
                    fontSize: 55.sp
                  ),
                  ),

                  //separacion de 20 px
                  SizedBox(height: 20,),

                  //Lista de planetas
                  Expanded(
                    child: ListaPlanetas(),
                  )
                  














                ],
              ),
            ),
            //
            



          ],
        )
        ),
    );
  }
}