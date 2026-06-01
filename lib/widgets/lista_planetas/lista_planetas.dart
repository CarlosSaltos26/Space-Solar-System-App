import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:space_solar_app/data/providers/planet_provider.dart';
import 'package:space_solar_app/data/models/planet_model.dart';
import 'package:space_solar_app/routes/app_router.dart';

class ListaPlanetas extends StatelessWidget {
  const ListaPlanetas({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Escuchamos el Provider que tiene los planetas en memoria
    final planetProvider = Provider.of<PlanetProvider>(context);
    
    // 2. Filtramos la lista para quedarnos solo con los planetas reales
    final List<PlanetModel> planetasApi = planetProvider.planets.where((b) => b.isPlanet).toList();

    final List<String> nombrePlanetaEsp = [
        'Mercurio',
        'Venus',
        'Tierra',
        'Marte',
        'Jupiter',
        'Saturno',
        'Urano',
        'Neptuno'
    ];

    // HACEMOS LA MAGIA DEL ORDENAMIENTO
    if (planetasApi.isNotEmpty) {
      // Definimos el orden estricto del Sistema Solar usando los IDs exactos de la API
      final List<String> ordenCorrectoIds = [
        'mercure',
        'venus',
        'terre',
        'mars',
        'jupiter',
        'saturne',
        'uranus',
        'neptune'
      ];

      // Ordenamos la lista original dinámicamente
      planetasApi.sort((a, b) {
        int indexA = ordenCorrectoIds.indexOf(a.id);
        int indexB = ordenCorrectoIds.indexOf(b.id);
        
        if (indexA == -1) indexA = 99;
        if (indexB == -1) indexB = 99;
        
        return indexA.compareTo(indexB);
      });
    }

    // Si la API sigue cargando en segundo plano, mostramos el indicador
    if (planetProvider.isLoading && planetasApi.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    // 3. Mapa local de assets asociados al ID de la API
    final Map<String, String> planetAssets = {
      'mercure': 'assets/planetas/mercurio.png',
      'venus': 'assets/planetas/venus.png',
      'terre': 'assets/planetas/tierra.png',
      'mars': 'assets/planetas/marte.png',
      'jupiter': 'assets/planetas/jupiter.png',
      'saturne': 'assets/planetas/saturno.png',
      'uranus': 'assets/planetas/urano.png',
      'neptune': 'assets/planetas/neptuno.png',
    };

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: planetasApi.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,       
        crossAxisSpacing: 12,    
        mainAxisSpacing: 12,     
        childAspectRatio: 0.85,  
      ),
      itemBuilder: (context, index) {
        // Obtenemos el objeto del planeta de la API en memoria
        final planet = planetasApi[index];
        
        // Buscamos su asset correspondiente
        final assetPath = planetAssets[planet.id] ?? 'assets/planetas/mercurio.png';

        return GestureDetector(
          onTap: () {
            // Enviamos el mapa con el planeta Y el index usando GoRouter
            context.push(
              AppRoutes.detail, 
              extra: {
                'planet': planet,
                'index': index, 
              },
            );
          },
          child: Card(
            color: Colors.white.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    // CORRECCIÓN: Leemos directamente el nombre del modelo mapeado de la API
                    nombrePlanetaEsp[index].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}