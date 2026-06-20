import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Responsive {
 
  static const double baseWidth = 1080;
  static const double baseHeight = 1920;

  @Deprecated('Ya no es necesario llamarlo: Responsive.w/h/sp leen el tamaño de pantalla actual automáticamente. Se deja solo para no romper código existente.')
  void init(BuildContext context) {
    
  }

  
  static Size get _currentScreenSize {
    final view = ui.PlatformDispatcher.instance.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  static double get screenWidth => _currentScreenSize.width;
  static double get screenHeight => _currentScreenSize.height;

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