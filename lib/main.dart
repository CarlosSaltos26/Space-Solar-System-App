import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_solar_app/data/providers/planet_provider.dart';
import 'routes/app_router.dart';
 // Tu archivo de rutas con GoRouter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Envolvemos la app con el Provider global
    return ChangeNotifierProvider(
      create: (context) => PlanetProvider(),
      child: MaterialApp.router(
        title: 'Space Solar System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(), // Tu configuración de tema
        routerConfig: appRouter, // Tu configuración de GoRouter
      ),
    );
  }
}