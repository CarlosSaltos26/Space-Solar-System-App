import 'package:go_router/go_router.dart';
import 'package:space_solar_app/data/models/planet_model.dart';
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
  builder: (context, state) {
    // 1. Convertimos el extra en un Mapa seguro
    final params = state.extra as Map<String, dynamic>;
    
    // 2. Extraemos cada propiedad de forma independiente con su tipo correcto
    final planetaseleccionado = params['planet'] as PlanetModel;
    final indexSeleccionado = params['index'] as int;
    
    // 3. Se los pasamos a la pantalla de detalle
    return DetailPlanet(
      planet: planetaseleccionado,
      planetIndex: indexSeleccionado, // Pasamos el entero
    );
  },
),



  ],
);