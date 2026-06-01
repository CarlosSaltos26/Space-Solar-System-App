import 'package:dio/dio.dart';
import 'package:space_solar_app/data/models/planet_model.dart';
// Importamos el modelo que hiciste

class ApiService {
  // Instanciamos Dio
  final Dio _dio = Dio();

  // La URL base de tu API
  final String _url = 'https://api.le-systeme-solaire.net/rest/bodies';

  // Función para obtener todos los cuerpos celestes
  Future<List<PlanetModel>> getPlanets() async {
    try {
      String apiKey = '7f5980c2-7eb2-4428-8957-b8fba778ac78';

      // Hacemos la petición GET
      final response = await _dio.get(
        _url,
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );

      if (response.statusCode == 200) {
        // La API devuelve un mapa con una lista llamada 'bodies'
        List<dynamic> data = response.data['bodies'];
        //print('¡API CONECTADA! Datos crudos del servidor: ${response.data}');
        // Convertimos cada elemento de esa lista en un PlanetModel
        //print(data);
        return data.map((json) => PlanetModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar datos');
      }
    } catch (e) {
      // Si algo sale mal (sin internet, URL rota, etc.)
      //print('Error en la petición: $e');
      return [];
    }
  }
}
