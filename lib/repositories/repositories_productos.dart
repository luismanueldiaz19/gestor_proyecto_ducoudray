import 'dart:convert';

import 'package:ducoudray/model/productos.dart';
import 'package:ducoudray/services/api_service.dart';
import 'package:ducoudray/utils/constants.dart';

class RepositoriesProductos {
  static final ApiService _api = ApiService();
  static const String baseUrl = 'http://$ipLocal/$pathHost/productos';
  static Future<List<Productos>> fetchProducto() async {
    final res = await _api.getRequest('$baseUrl/get_producto.php');
    // print(res);
    final value = json.decode(res);
    if (value['success']) {
      return productosFromJson(json.encode(value['data']));
    }

    return <Productos>[];
  }

  /// Crear nuevo cliente
  static Future<bool> createProductos(jsonValue) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/agregar_producto.php',
      json.encode(jsonValue),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }

  static Future<bool> eliminarProductos(jsonValue) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/eliminar_producto.php',
      json.encode(jsonValue),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }
}
