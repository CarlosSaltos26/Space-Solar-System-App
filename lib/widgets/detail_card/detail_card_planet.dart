import 'package:flutter/material.dart';
import 'package:space_solar_app/core/responsive_helper.dart';
import 'package:space_solar_app/data/models/planet_model.dart'; // Importamos el modelo
import 'package:space_solar_app/theme/theme_data.dart';

class DetailCardPlanet extends StatefulWidget {
  // 1. Recibimos el planeta seleccionado desde la pantalla de detalle
  final PlanetModel planet;
  final int planetIndex;

  final List<String> datosPlanetas = [
    'El mundo más cercano al Sol. Es un desierto de extremos térmicos, sin atmósfera y cubierto de cráteres, donde un año dura apenas 88 días',
    'El gemelo malvado de la Tierra. Está envuelto en una densa atmósfera de invernadero que atrapa el calor, convirtiéndolo en el planeta más caliente.',
    'Nuestro oasis cósmico. El único mundo conocido con agua líquida en superficie, una atmósfera perfecta y el milagro de la vida en abundancia.',
    'El planeta rojo. Un desierto frío y polvoriento con canales secos y volcanes gigantes, que hoy es el principal objetivo de la exploración espacial.',
    'El gigante gaseoso y rey del Sistema Solar. Una enorme bola de hidrógeno y helio con tormentas milenarias y más de noventa lunas.',
    'La joya del vecindario. Famoso por su espectacular y complejo sistema de anillos de hielo y roca, es el segundo planeta más grande.',
    'El gigante de hielo que rueda de lado. Su eje de rotación está totalmente inclinado, y su atmósfera de metano le da un tono azulado.',
    'El titán azul y el más lejano del Sol. Un mundo helado azotado por los vientos más rápidos y violentos de todo el Sistema Solar.',
    
  ];  

  DetailCardPlanet({super.key, required this.planet, required this.planetIndex});

  @override
  State<DetailCardPlanet> createState() => _DetailCardPlanetState();
}

class _DetailCardPlanetState extends State<DetailCardPlanet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    // 2. Construimos las listas dinámicamente usando "widget.planet" para leer la memoria de la API
    
    // --- PÁGINA 1: Datos reales de la API ---
    final List<Map<String, dynamic>> datosPagina1 = [
      {
        'iconNum': 1, 
        'label': 'Temperatura', 
        // EXPLICACIÓN DEL DATO: Accedemos a widget.planet.temperature y le concatenamos la unidad string.
        'value': '${widget.planet.temperature} °C' 
      },
      {
        'iconNum': 2, 
        'label': 'Gravedad', 
        // EXPLICACIÓN DEL DATO: Usamos la propiedad gravity de tu modelo.
        'value': '${widget.planet.gravity} m/s²' 
      },
      {
        'iconNum': 3, 
        'label': 'Distancia Sol', 
        // PRÁCTICA: Modifica este campo usando 'widget.planet.semimajorAxis' cuando completes los datos
        'value': '${(widget.planet.semimajorAxis / 1000000).toStringAsFixed(1)}M km' 
      },
    ];

    // --- PÁGINA 2: ---
    final List<Map<String, dynamic>> datosPagina2 = [
      {'iconNum': 4, 'label': 'Anomalía', 'value': '${widget.planet.anomalia}°'}, 
      {'iconNum': 5, 'label': 'Rot. Sideral', 'value': '${widget.planet.sideral} días'},
      {'iconNum': 6, 'label': 'Rot. Orbital', 'value': '${widget.planet.rotacion} días'},  
    ];

    // --- PÁGINA 3:  ---
    final List<Map<String, dynamic>> datosPagina3 = [
      {'iconNum': 7, 'label': 'Densidad', 'value': '${widget.planet.densidad} g/cm³'}, 
      {'iconNum': 8, 'label': 'Lunas', 'value': '${widget.planet.moons}'},             
      {'iconNum': 9, 'label': 'Radio Polar', 'value': '${widget.planet.polar} km'},
    ];

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

                Text(
                  widget.datosPlanetas[widget.planetIndex],
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Montserrat',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 35.h),

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
                      // Pasamos las variables locales que ya computan los datos dinámicos
                      _buildGridInfo(datosPagina1),
                      _buildGridInfo(datosPagina2),
                      _buildGridInfo(datosPagina3),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),

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

  // Tu función de diseño _buildGridInfo y _buildIndicator se quedan exactamente igual...
  Widget _buildGridInfo(List<Map<String, dynamic>> data) {
     // ... (Tu código actual de GridView.count se mantiene idéntico sin cambios)
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 65.h,
                child: Image.asset('assets/icons/icono${item['iconNum']}.png', fit: BoxFit.contain),
              ),
              SizedBox(height: 12.h),
              Text(
                item['label'].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.sp, color: AppTheme.spaceOrange, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6.h),
              Text(
                item['value'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.sp, color: Colors.white, fontWeight: FontWeight.bold),
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