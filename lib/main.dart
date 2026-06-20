import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_solar_app/data/providers/planet_provider.dart';
import 'package:space_solar_app/data/services/audio_service.dart';
import 'package:space_solar_app/theme/theme_data.dart';
import 'routes/app_router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlanetProvider()),
        ChangeNotifierProvider(create: (context) => AudioService()),
      ],
      child: MaterialApp.router(
        title: 'Space Solar System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme, // Configuración de tema
        routerConfig: appRouter, // Configuración de GoRouter
      ),
    );
  }
}