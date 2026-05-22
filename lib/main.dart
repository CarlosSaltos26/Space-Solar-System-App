import 'package:flutter/material.dart';
import 'package:space_solar_app/routes/app_router.dart';
import 'package:space_solar_app/theme/theme_data.dart';
//import 'package:space_solar_app/screens/splash/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      //home: SplashScreen(),
    );
  }
}
