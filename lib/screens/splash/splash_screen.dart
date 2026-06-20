import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/routes/app_router.dart';
import 'package:space_solar_app/widgets/animated_logo/animated_logo.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/animated_start_field/animated_start_field.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    
    // Lógica de espera y salto
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        // Usamos context.go para que no pueda regresar al splash con el botón atrás
        
        //Aqui vuelvo leugo que tenga la pantalla detale lista
        //context.go(AppRoutes.home);
        context.go(AppRoutes.home);  
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // 1. Inicializar el helper
    // Esto toma las medidas de la pantalla actual y las prepara para las fórmulas.
    Responsive().init(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
      children: [
        BackgroundGradient(),
        
        Positioned.fill(child: AnimatedStarField()),

        Center(
            child: SizedBox(
              // 3. AQUÍ USAS EL RESPONSIVE
              // Si en tu diseño de 1080px el logo medía 600px, pones 600.w
              width: 900.w, 
              height: 900.w, 
              child: const AnimatedLogo(),
            ),
          ),
      ],
    ),
    );
    
    
  }
}

