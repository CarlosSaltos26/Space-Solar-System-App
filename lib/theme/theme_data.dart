import 'package:flutter/material.dart';

class AppTheme {
  static const Color spaceOrange = Color(0xFFfca312); // Tu nuevo color vibrante

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: spaceOrange,
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Montserrat',
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0E21), 
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spaceOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}