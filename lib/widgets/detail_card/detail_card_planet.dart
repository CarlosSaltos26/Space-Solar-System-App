import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/theme/theme_data.dart';

class DetailCardPlanet extends StatefulWidget {
  const DetailCardPlanet({super.key});

  @override
  State<DetailCardPlanet> createState() => _DetailCardPlanetState();
}

class _DetailCardPlanetState extends State<DetailCardPlanet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- ESTRUCTURA DE 9 DATOS EN ORDEN ESTRICTO (3 POR PÁGINA) ---
  final List<Map<String, dynamic>> _datosPagina1 = [
    {'iconNum': 1, 'label': 'Temperatura', 'value': '167 °C'},
    {'iconNum': 2, 'label': 'Gravedad', 'value': '3.7 m/s²'},
    {'iconNum': 3, 'label': 'Distancia Sol', 'value': '57.9M km'},
  ];

  final List<Map<String, dynamic>> _datosPagina2 = [
    {'iconNum': 4, 'label': 'Anomalía', 'value': '230.3°'},
    {'iconNum': 5, 'label': 'Rot. Sideral', 'value': '58.6 días'},
    {'iconNum': 6, 'label': 'Rot. Orbital', 'value': '88 días'},
  ];

  final List<Map<String, dynamic>> _datosPagina3 = [
    {'iconNum': 7, 'label': 'Densidad', 'value': '5.43 g/cm³'},
    {'iconNum': 8, 'label': 'Lunas', 'value': '0'},
    {'iconNum': 9, 'label': 'Radio Polar', 'value': '2,439 km'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "GENERALIDADES",
                    style: TextStyle(
                      fontSize: 50.sp,
                      color: AppTheme.spaceOrange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                // Resumen del Planeta Mercurio
                Text(
                  "Mercurio es el planeta más pequeño de nuestro sistema solar y el más cercano al Sol. Su superficie está plagada de cráteres debido al impacto constante de meteoritos, y al no poseer una atmósfera densa, experimenta las variaciones de temperatura más extremas de todo el sistema.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 34.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Montserrat',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 35.h),

                // Deslizador (Swipe) con altura optimizada para las 3 páginas
                SizedBox(
                  height: 280.h, 
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildGridInfo(_datosPagina1),
                      _buildGridInfo(_datosPagina2),
                      _buildGridInfo(_datosPagina3),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),

                // Indicador de páginas actualizado a 3 puntitos (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildIndicator(index == _currentPage)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- CUADRITOS CORREGIDOS CON BORDER.ALL Y TEXTOS MÁS GRANDES ---
  Widget _buildGridInfo(List<Map<String, dynamic>> data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      children: data.map((item) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(15),       
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4), // Contorno de 1px guardado sin errores
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 65.h, // Icono ligeramente adaptado
                child: Image.asset(
                  'assets/icons/icono${item['iconNum']}.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                item['label'].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp, // Un pelín más grande como me pediste
                  color: AppTheme.spaceOrange,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item['value'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.sp, // Valor numérico resaltado e imponente
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.spaceOrange : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}