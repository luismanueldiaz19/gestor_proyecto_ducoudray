import 'dart:convert';
import 'package:ducoudray/utils/constants.dart';

import '../model/proveedor.dart';
import '../services/api_service.dart';

class ProveedorRepositories {
  static final ApiService _api = ApiService();
  static const String baseUrl = 'http://$ipLocal/$pathHost/proveedor';
// List<Proveedor> proveedorFromJson(
  /// Obtener todos los clientes
  static Future<List<Proveedor>> fetchProveedor() async {
    final res = await _api.httpEnviaMap(
        '$baseUrl/get_proveedor.php', jsonEncode({'view': 'view'}));
    // print(res);
    final value = json.decode(res);
    if (value['success']) {
      return proveedorFromJson(json.encode(value['data']));
    }

    return <Proveedor>[];
  }

  /// Crear nuevo cliente
  static Future<bool> createProveedor(jsonValue) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/add_proveedor.php',
      json.encode(jsonValue),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }

  static Future<bool> actualizarProveedor(jsonValue) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/actualizar_proveedor.php',
      jsonEncode(jsonValue),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }
  // Métodos adicionales como update/delete se pueden agregar aquí
}
