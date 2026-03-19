import 'dart:convert';

import 'package:ducoudray/proyectos/model/proyecto.dart';
import 'package:ducoudray/services/api_service.dart';
import 'package:ducoudray/utils/constants.dart';

class RepositorieProyecto {
  static final ApiService _api = ApiService();
  static const String baseUrl = 'http://$ipLocal/$pathHost/proyectos';

  /// Obtener todos los clientes
  static Future<List<Proyecto>> fetchProyectos() async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/obtener_proyecto_activo.php',
      jsonEncode({"view": "view"}),
    );

    final value = json.decode(res);
    if (value['success']) {
      return proyectoFromJson(json.encode(value['data']));
    }
    return <Proyecto>[];
  }

  static Future<Map<String, dynamic>> agregarProyectoCompleto(
    Map<String, dynamic> jsonValue,
  ) async {
    return await _postRequest(
      endpoint: 'agregar_proyecto_completo.php',
      body: jsonValue,
    );
  }

  static Future<Map<String, dynamic>> _postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/$endpoint',
        jsonEncode(body),
      );

      final valueJson = json.decode(res) as Map<String, dynamic>;

      final success = valueJson['success'] == true;

      if (!success) {
        return {
          'success': false,
          'message': valueJson['message'] ?? 'Error en la petición',
        };
      }

      return valueJson;
    } on FormatException catch (e) {
      return {
        'success': false,
        'message': 'Respuesta inválida del servidor: $e',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
}
