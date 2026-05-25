import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_solar_app/data/providers/planet_provider.dart';
import 'package:space_solar_app/data/services/api_service.dart';
import 'package:space_solar_app/widgets/background_gradient/background_gradient.dart';
import 'package:space_solar_app/widgets/btn_explorar/boton_explorar.dart';
import 'package:space_solar_app/widgets/logo/logotipo.dart';
import 'package:space_solar_app/widgets/sistema_solar/sistema_solar.dart';
import 'package:space_solar_app/widgets/start_field/start_field.dart';
import 'package:space_solar_app/widgets/sun/sun.dart';

class HomeScreen extends StatelessWidget {
   const HomeScreen({super.key});

  //final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {

    

    // Ponemos este bloque justo aquí para disparar la petición en segundo plano
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // listen: false es CRUCIAL aquí para que dispare la función sin redibujar el HomeScreen innecesariamente
    final provider = Provider.of<PlanetProvider>(context, listen: false);

   
    // 2. Esperamos a que termine de descargar
    await provider.fetchPlanets();
    
    // 👇 3. AQUÍ PONEMOS EL PRINT 
    print('¡Planetas listos en Provider! Total cargados: ${provider.planets.length}');
    
    // Si quieres imprimir el nombre del primer objeto de la lista para probar:
    if(provider.planets.isNotEmpty) {
      print('Primer cuerpo celeste en la lista: ${provider.planets.first.englishName}');
    }
    
  });

    return Scaffold(
      body: Stack(
        children: [
          //Fondo con gradiente
          BackgroundGradient(),
          //Fondo de estrellas
          StarField(),
          //sol centrado
          Center(child: Sun()),
          //logotipo superior
          Logotipo(),
          //Animacion sistema solar
          SistemaSolar(),

          

          //Boton Explorar planetas
          BotonExplorar(),

          
        ],
      ),
    );
  }
}
