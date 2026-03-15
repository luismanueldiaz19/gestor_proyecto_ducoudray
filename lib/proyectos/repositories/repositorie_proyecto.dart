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
}
