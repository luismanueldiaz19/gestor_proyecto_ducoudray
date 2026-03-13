import 'dart:convert';

import '../model/roles.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class PermissionServices {
  static final ApiService _api = ApiService();

  // Puedes definir baseUrl aquí o recibirla como parámetro/constructor
  static const String baseUrl = 'http://$ipLocal/$pathHost/permissions';

  Future<List<Roles>> getRolesAndPermissions() async {
    final res =
        await _api.getRequest('$baseUrl/get_roles_with_permissions.php');

    final jsonData = json.decode(res);

    // print(jsonEncode(jsonData['roles']));

    if (jsonData['success'] != true) {
      throw Exception('Error en el servidor: ${jsonData['message']}');
    }

    return rolesFromJson(jsonEncode(jsonData['roles']));
  }

  Future<bool> updateUserRoles(int usuarioId, List<int> roles) async {
    final body = {'usuario_id': usuarioId, 'roles': roles};
    final res = await _api.httpEnviaMap(
        '$baseUrl/actualizar_roles.php', jsonEncode(body));
    final jsonData = json.decode(res);
    if (jsonData['success'] == true) {
      return true;
    } else {
      throw Exception('Error al actualizar roles: ${jsonData['error']}');
    }
  }
}
