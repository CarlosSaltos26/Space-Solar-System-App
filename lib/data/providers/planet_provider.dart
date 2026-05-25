import 'package:flutter/material.dart';
import 'package:space_solar_app/data/models/planet_model.dart';
import 'package:space_solar_app/data/services/api_service.dart';


class PlanetProvider extends ChangeNotifier {
  // Instanciamos el servicio que creamos en el paso anterior
  final ApiService _apiService = ApiService();

  // Aquí guardaremos la lista de planetas una vez descargada
  List<PlanetModel> _planets = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters para que las pantallas lean los datos de forma segura
  List<PlanetModel> get planets => _planets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Esta función la dispararemos en segundo plano
  Future<void> fetchPlanets() async {
    _isLoading = true;
    _errorMessage = '';
    // Avisamos a las pantallas que está cargando (por si acaso)
    notifyListeners(); 

    try {
      // Llamamos a Dio mediante nuestro servicio
      final fetchedPlanets = await _apiService.getPlanets();
      
      // Filtramos opcionalmente para quedarnos solo con los planetas reales si deseas
      // o guardamos todo el listado directo de la API:
      _planets = fetchedPlanets;
    } catch (e) {
      _errorMessage = 'No se pudo conectar con el cosmos: $e';
    } finally {
      _isLoading = false;
      // ¡Magia! Avisamos a toda la app que los datos ya están listos en memoria
      notifyListeners(); 
    }
  }
}