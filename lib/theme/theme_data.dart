import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      // Aquí puedes agregar tus colores principales de la app si deseas
      scaffoldBackgroundColor: const Color(0xFF0A0E21), 
      
      // CONFIGURACIÓN GLOBAL DEL ELEVATED BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFfca312), // El amarillo para tu botón
          foregroundColor: Colors.white,            // Color del texto/icono sobre el amarillo
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          shape: const StadiumBorder(), // Esto hace que el botón sea completamente ovalado (como una píldora)
        ),
      ),
    );
  }
}