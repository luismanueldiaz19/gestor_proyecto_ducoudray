import 'dart:convert';

import 'package:ducoudray/model/usuario.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/constants.dart';
import 'permission_services.dart';

class UsuariosServices {
  PermissionServices permissionServices = PermissionServices();
  static final ApiService _api = ApiService();

  // Puedes definir baseUrl aquí o recibirla como parámetro/constructor
  static const String baseUrl = 'http://$ipLocal/$pathHost/usuario';

  Future<List<Usuario>> getAllUsuarios() async {
    final res = await _api.getRequest('$baseUrl/get_usuarios.php');
    final jsonData = json.decode(res);

    print(jsonData);
    if (jsonData['success'] != true) {
      // throw Exception('Error en el servidor: ${jsonData['message']}');
    }

    return usuarioFromJson(jsonEncode(jsonData['usuarios']));
    // return [];
  }

  Future<List<Usuario>> getAllDriver() async {
    final res = await _api.getRequest('$baseUrl/get_driver.php');
    final jsonData = json.decode(res);
    // print(jsonEncode(jsonData['usuarios']));
    if (jsonData['success'] != true) {
      throw Exception('Error en el servidor: ${jsonData['message']}');
    }

    return usuarioFromJson(jsonEncode(jsonData['usuarios']));
  }

  Future<bool> updateUserRoles(int usuarioId, List<int> roles) async {
    return await permissionServices.updateUserRoles(usuarioId, roles);
  }

  Future<bool> crearUsuarioNuevo(Map<String, dynamic> data) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/insert_usuario.php',
      jsonEncode(data),
    );
    final jsonData = json.decode(res);
    if (jsonData['success'] != true) {
      throw Exception('Error al crear usuario: ${jsonData['message']}');
    }

    return true;
  }

  Future<bool> crearLicenseDriver(Map<String, dynamic> data) async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/insert_licencia.php',
      jsonEncode(data),
    );
    final jsonData = json.decode(res);
    if (jsonData['success'] != true) {
      throw Exception('Error al crear usuario: ${jsonData['message']}');
    }

    return true;
  }

  Future<Usuario?> loginUser(BuildContext context, data) async {
    try {
      final res = await _api.httpEnviaMap(
        '$baseUrl/login.php',
        jsonEncode(data),
      );

      if (res == null || res.isEmpty) {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo conectar con el servidor'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }

      late Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(res);
      } catch (e) {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Respuesta inválida del servidor'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }

      if (jsonData['success'] != true) {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message'] ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.orange,
          ),
        );
        return null;
      }

      return Usuario.fromJson(jsonData);
    } catch (e) {
      // Error general (sin internet, timeout, servidor caído, etc.)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión al servidor'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  ///http://localhost/serkasa/usuario/get_driver_all_licencia.php
  ///
  ///
  Future<List<Usuario>> getDriverAllLicencia() async {
    final res = await _api.httpEnviaMap(
      '$baseUrl/get_driver_all_licencia.php',
      jsonEncode({'view': 'view'}),
    );
    final jsonData = json.decode(res);
    // print(jsonEncode(jsonData['usuarios']));
    if (jsonData['success'] != true) {
      throw Exception('Error en el servidor: ${jsonData['message']}');
    }
    return usuarioFromJson(jsonEncode(jsonData['data']));
  }
}
