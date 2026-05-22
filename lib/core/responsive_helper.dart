import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  //static late double _safeAreaHorizontal;
  //static late double _safeAreaVertical;

  // Define aquí el tamaño de pantalla que usaste en tu diseño (ej. Figma)
  // Normalmente se usa 375x812 o 360x800
  static const double baseWidth = 1080;
  static const double baseHeight = 1920;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    
    //_safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    //_safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  }

  // Obtener el ancho proporcional
  static double w(double inputWidth) {
    return (inputWidth / baseWidth) * screenWidth;
  }

  // Obtener el alto proporcional
  static double h(double inputHeight) {
    return (inputHeight / baseHeight) * screenHeight;
  }

  // Obtener tamaño de fuente proporcional (usa el ancho para evitar que la letra crezca de más)
  static double sp(double inputFontSize) {
    return (inputFontSize / baseWidth) * screenWidth;
  }
}

// Extensiones para escribir menos código (Sintaxis Pro)
extension ResponsiveDouble on num {
  double get w => Responsive.w(toDouble());
  double get h => Responsive.h(toDouble());
  double get sp => Responsive.sp(toDouble());
}