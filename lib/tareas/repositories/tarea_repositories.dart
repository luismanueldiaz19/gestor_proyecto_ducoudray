import 'dart:convert';

import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../model/tarea_historia.dart';
import '../model/tarea_pendientes.dart';
import '../model/tiempo_tareas.dart';

class TareaRepositories {
  static final ApiService _api = ApiService();
  static const String baseUrl = 'http://$ipLocal/$pathHost/tiempos';

  static Future<List<TareaHistoria>> getTareaHistoria(payload) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/get_historia_tareas.php',
        jsonEncode(payload),
      );

      final valueJson = json.decode(res);

      if (valueJson['success'] != true) {
        // debugPrint("Error en getAllPedidos: ${valueJson['message'] ?? 'Error desconocido'}");
        return []; // Devuelve lista vacía si la API responde con error
      }

      return tareaHistoriaFromJson(json.encode(valueJson['data']));
    } catch (e) {
      return []; // Devuelve lista vacía si ocurre excepción
    }
  }

  static Future<List<TareaPendiente>> getTareaCurrent({String? usuario}) async {
    try {
      final res = await _api.postRequest('$baseUrl/get_tareas_pendientes.php', {
        'usuario': usuario ?? '',
      });

      final valueJson = json.decode(res);

      if (valueJson['success'] != true) {
        // debugPrint("Error en getAllPedidos: ${valueJson['message'] ?? 'Error desconocido'}");
        return []; // Devuelve lista vacía si la API responde con error
      }

      return tareaPendienteFromJson(json.encode(valueJson['data']));
    } catch (e) {
      return []; // Devuelve lista vacía si ocurre excepción
    }
  }

  // List<TiempoTarea> tiempoTareaFromJson(
  static Future<List<TiempoTarea>> getTiempoTareas(tareaId) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/get_item_tareas.php',
        jsonEncode({"tarea_id": int.parse(tareaId)}),
      );

      final valueJson = json.decode(res);

      if (valueJson['success'] != true) {
        // debugPrint("Error en getAllPedidos: ${valueJson['message'] ?? 'Error desconocido'}");
        return []; // Devuelve lista vacía si la API responde con error
      }

      return tiempoTareaFromJson(json.encode(valueJson['data']));
    } catch (e) {
      return []; // Devuelve lista vacía si ocurre excepción
    }
  }

  static Future<bool> elimninarTarea(jsonValue) async {
    try {
      final response = await _api.httpEnviaMap(
        '$baseUrl/eliminar_tarea.php',
        jsonEncode(jsonValue),
      );

      final Map<String, dynamic> jsonData = json.decode(response);

      if (jsonData['success'] == true) {
        // debugPrint('✅ Vacaciones agregadas con éxito: $jsonData');
        return true;
      } else {
        // debugPrint('⚠️ Error al agregar vacaciones: $jsonData');
        return false;
      }
    } catch (e) {
      // var da = {"id_pedido": 1};

      return false;
    }
  }

  ///http://localhost/serkasa/tiempos/actualizar_tarea.php
  ///
  ///
  static Future<bool> actualizarTask(jsonValue) async {
    try {
      final response = await _api.httpEnviaMap(
        '$baseUrl/actualizar_tarea.php',
        jsonEncode(jsonValue),
      );

      final Map<String, dynamic> jsonData = json.decode(response);

      if (jsonData['success'] == true) {
        // debugPrint('✅ Vacaciones agregadas con éxito: $jsonData');
        return true;
      } else {
        // debugPrint('⚠️ Error al agregar vacaciones: $jsonData');
        return false;
      }
    } catch (e) {
      // var da = {"id_pedido": 1};

      return false;
    }
  }

  static Future<bool> elimninarTiempo(jsonValue) async {
    try {
      final response = await _api.httpEnviaMap(
        '$baseUrl/eliminar_tiempo.php',
        jsonEncode(jsonValue),
      );

      final Map<String, dynamic> jsonData = json.decode(response);

      if (jsonData['success'] == true) {
        // debugPrint('✅ Vacaciones agregadas con éxito: $jsonData');
        return true;
      } else {
        // debugPrint('⚠️ Error al agregar vacaciones: $jsonData');
        return false;
      }
    } catch (e) {
      // var da = {"id_pedido": 1};

      return false;
    }
  }

  static Future<Map<String, dynamic>> agregarTiempo(
    Map<String, dynamic> jsonValue,
  ) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/insert_tiempo.php',
        jsonEncode(jsonValue),
      );

      final valueJson = json.decode(res) as Map<String, dynamic>;

      // Validación más explícita
      final success = valueJson['success'] == true;
      if (!success) {
        return {
          'success': false,
          'message':
              valueJson['message'] ?? 'Error desconocido en agregarTiempo',
        };
      }

      return valueJson;
    } on FormatException catch (e) {
      // Error al decodificar JSON
      return {
        'success': false,
        'message': 'Respuesta inválida del servidor: $e',
      };
    } catch (e) {
      // Error genérico
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  static Future<Map<String, dynamic>> teminarTiempo(
    Map<String, dynamic> jsonValue,
  ) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/cerrar_tiempo.php',
        jsonEncode(jsonValue),
      );

      final valueJson = json.decode(res) as Map<String, dynamic>;

      // Validación más explícita
      final success = valueJson['success'] == true;
      if (!success) {
        return {
          'success': false,
          'message':
              valueJson['message'] ?? 'Error desconocido en agregarTiempo',
        };
      }

      return valueJson;
    } on FormatException catch (e) {
      // Error al decodificar JSON
      return {
        'success': false,
        'message': 'Respuesta inválida del servidor: $e',
      };
    } catch (e) {
      // Error genérico
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  static Future<Map<String, dynamic>> agregarTask(
    Map<String, dynamic> jsonValue,
  ) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/agregar_tarea.php',
        jsonEncode(jsonValue),
      );

      final valueJson = json.decode(res) as Map<String, dynamic>;

      // Validación más explícita
      final success = valueJson['success'] == true;
      if (!success) {
        return {
          'success': false,
          'message':
              valueJson['message'] ?? 'Error desconocido en agregarTiempo',
        };
      }

      return valueJson;
    } on FormatException catch (e) {
      // Error al decodificar JSON
      return {
        'success': false,
        'message': 'Respuesta inválida del servidor: $e',
      };
    } catch (e) {
      // Error genérico
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
}
