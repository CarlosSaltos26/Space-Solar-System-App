class PlanetModel {
  final String id;
  final String name; // Nombre original
  final double gravity;
  final bool isPlanet;
  final double temperature;
  final double semimajorAxis;
  final double anomalia;
  final double sideral;
  final double rotacion;
  final double densidad;
  final int moons;
  final double polar;

  PlanetModel({
    required this.id,
    required this.name,
    required this.gravity,
    required this.isPlanet,
    required this.temperature,
    required this.semimajorAxis,
    required this.anomalia,
    required this.sideral,
    required this.rotacion,
    required this.densidad,
    required this.moons,
    required this.polar,
  });

  // Convierte el JSON que viene de la web a un objeto Dart
  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // La API a veces manda la gravedad como int o double, esto lo asegura:
      gravity: (json['gravity'] ?? 0.0).toDouble(),
      isPlanet: json['isPlanet'] ?? false,
      temperature: (json['avgTemp'] ?? 0.0).toDouble(),
      semimajorAxis: (json['semimajorAxis'] ?? 0.0).toDouble(),
      anomalia: (json['mainAnomaly'] ?? 0.0).toDouble(),
      sideral: (json['sideralOrbit'] ?? 0.0).toDouble(),
      rotacion: (json['sideralRotation'] ?? 0.0).toDouble(),
      densidad: (json['density'] ?? 0.0).toDouble(),
      moons: json['moons'] != null ? (json['moons'] as List).length : 0,
      polar: (json['polarRadius'] ?? 0.0).toDouble(),
    );
  }
}