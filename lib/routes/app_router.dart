import 'package:go_router/go_router.dart';
import 'package:space_solar_app/screens/detail_planet/detail_planet.dart';
import 'package:space_solar_app/screens/home/home_screen.dart';
import 'package:space_solar_app/screens/planet_list/planet_list.dart';
import 'package:space_solar_app/screens/splash/splash_screen.dart';

//Aqui se cambia las rutas para todo el archivo
class AppRoutes{
  static const String splash = '/splash_screen';
  static const String home = '/home_screen';
  static const String planets = '/planet_list';
  static const String detail = '/planet_detail';
}

// GoRouter configuration
final appRouter = GoRouter(

  initialLocation: AppRoutes.splash,

  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.planets,
      builder: (context, state) => PlanetList(),
    ),

    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) => DetailPlanet(),
    ),



  ],
);