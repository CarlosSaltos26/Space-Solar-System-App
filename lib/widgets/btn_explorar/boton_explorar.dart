import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_solar_app/routes/app_router.dart';

class BotonExplorar extends StatelessWidget {
  const BotonExplorar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: (){

            context.go(AppRoutes.planets);

          },
          child: Text('Explorar Planetas'))
      ),
    );
  }
}