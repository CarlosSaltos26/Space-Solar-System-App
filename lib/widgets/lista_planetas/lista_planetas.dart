import 'package:flutter/material.dart';

class ListaPlanetas extends StatelessWidget {
  const ListaPlanetas({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> planetas = [
      {'nombre': 'Mercurio', 'asset': 'assets/planetas/mercurio.png'},
      {'nombre': 'Venus', 'asset': 'assets/planetas/mercurio.png'}, // Ojo: luego cambias este asset a venus.png
      {'nombre': 'Tierra', 'asset': 'assets/planetas/tierra.png'},
      {'nombre': 'Marte', 'asset': 'assets/planetas/marte.png'},
      {'nombre': 'Jupiter', 'asset': 'assets/planetas/jupiter.png'},
      {'nombre': 'Saturno', 'asset': 'assets/planetas/saturno.png'},
      {'nombre': 'Urano', 'asset': 'assets/planetas/urano.png'},
      {'nombre': 'Neptuno', 'asset': 'assets/planetas/neptuno.png'},
    ];

    // 🚀 Usamos GridView en lugar de ListView para hacer la cuadrícula de 2 en 2
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: planetas.length,
      // GridDelegate controla la estructura física de la cuadrícula
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,       // 👈 ¡Aquí defines que aparezcan exactamente DOS planetas por fila!
        crossAxisSpacing: 12,    // Espacio horizontal entre las dos tarjetas
        mainAxisSpacing: 12,     // Espacio vertical entre filas
        childAspectRatio: 0.85,  // Relación de aspecto (Ancho / Alto). Ajusta este número para hacerlas más altas o bajas
      ),
      itemBuilder: (context, index) {
        final planeta = planetas[index];

        return Card(
          color: Colors.white.withValues(alpha: 0.05),
          elevation: 1,
          margin: EdgeInsets.zero, // El GridView ya maneja el espaciado con mainAxisSpacing
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen del Planeta ocupando el espacio principal de la tarjeta
                Expanded(
                  child: Image.asset(
                    planeta['asset']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.public, color: Colors.blueGrey, size: 50);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Nombre del Planeta abajo de la imagen
                Text(
                  planeta['nombre']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}