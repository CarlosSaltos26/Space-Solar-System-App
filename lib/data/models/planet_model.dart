class PlanetModel {
  final String id;
  final String name; // Nombre original
  final String englishName; // Nombre Inglés
  final double gravity;
  final bool isPlanet;

  PlanetModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.gravity,
    required this.isPlanet,
  });

  // Convierte el JSON que viene de la web a un objeto Dart
  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      // La API a veces manda la gravedad como int o double, esto lo asegura:
      gravity: (json['gravity'] ?? 0.0).toDouble(),
      isPlanet: json['isPlanet'] ?? false,
    );
  }
}