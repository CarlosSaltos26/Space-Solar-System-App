import 'package:flutter/material.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/btn_explorar/boton_explorar.dart';
import 'package:space_solar_app/widgets/logo/logotipo.dart';
import 'package:space_solar_app/widgets/sistema_solar/sistema_solar.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';
import 'package:space_solar_app/widgets/sun/sun.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Fondo con gradiente
          BackgroundGradient(),
          //Fondo de estrellas
          StarField(),
          //sol centrado
          Center(child: Sun()),
          //logotipo superior
          Logotipo(),
          //Animacion sistema solar
          SistemaSolar(),
          //Boton Explorar planetas
          BotonExplorar(),

          
        ],
      ),
    );
  }
}
