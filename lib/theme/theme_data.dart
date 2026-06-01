import 'package:flutter/material.dart';

class AppTheme {
  static const Color spaceOrange = Color(0xFFfca312); // Tu color vibrante

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      // Usar colorScheme es la clave para Material 3
      colorScheme: const ColorScheme.dark(
        primary: spaceOrange,
        secondary: spaceOrange,
      ),
      primaryColor: spaceOrange, // Mantenlo por compatibilidad
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Montserrat', //
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0E21), //
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spaceOrange, //
          foregroundColor: Colors.white, // Color del texto[cite: 2]
          elevation: 2, //[cite: 2]
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8), //[cite: 2]
          textStyle: const TextStyle(
            fontSize: 14, //[cite: 2]
            fontWeight: FontWeight.bold, //[cite: 2]
            letterSpacing: 0.5, //[cite: 2]
          ),
          shape: const StadiumBorder(), //[cite: 2]
        ),
      ),
    );
  }
}