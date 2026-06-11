import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/routes/app_router.dart';
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
  Responsive().init(context);
  
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          // Fondo degradado
          BackgroundGradient(),
          // Fondo de estrellas
          StarField(),

          // ✅ Column sin el botón
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Logotipo(),
                SizedBox(height: 10),
                Text(
                  "PLANETAS DEL SISTEMA SOLAR",
                  style: TextStyle(fontSize: 55.sp),
                ),
                SizedBox(height: 15),
                Expanded(child: ListaPlanetas()),
              ],
            ),
          ),

          // ✅ Botón ahora sí es hijo directo del Stack
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/icono.png',
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
