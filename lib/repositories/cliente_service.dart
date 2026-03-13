import 'dart:convert';
import 'package:ducoudray/utils/constants.dart';

import '../services/api_service.dart';
import '../model/cliente.dart';

class ClienteService {
  static final ApiService _api = ApiService();
  static const String baseUrl = 'http://$ipLocal/$pathHost/cliente';

  /// Obtener todos los clientes
  static Future<List<Cliente>> fetchClientes() async {
    final res = await _api.httpEnviaMap(
        '$baseUrl/read_cliente.php', jsonEncode({"view": "view"}));
    print(res);
    final value = json.decode(res);
    if (value['success']) {
      return clienteFromJson(json.encode(value['data']));
    }

    return <Cliente>[];
  }

  /// Obtener cliente por ID
  static Future<Cliente> getClienteById(int id) async {
    print('Buscando Cliente...');
    final res = await _api.httpEnviaMap(
      '$baseUrl/get_by_id.php',
      jsonEncode({'cliente_id': id}),
    );

    final decoded = json.decode(res);
    if (decoded['success'] == true) {
      return Cliente.fromJson(decoded['cliente']);
    } else {
      throw Exception(decoded['message'] ?? "Error al obtener el cliente");
    }
  }

  /// Crear nuevo cliente
  static Future<bool> createCliente(Cliente cliente) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/create_cliente.php',
      json.encode(cliente.toJson()),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }

  static Future<bool> actualizarCliente(Cliente cliente) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/update_cliente.php',
      json.encode(cliente.toJson()),
    );
    final value = json.decode(res);
    if (value['success']) {
      return true;
    }
    return false;
  }

  // Métodos adicionales como update/delete se pueden agregar aquí
}
