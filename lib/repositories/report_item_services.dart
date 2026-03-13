import 'dart:convert';

import '../model/reporte_item.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class ReportItemServices {
  static final ApiService _api = ApiService();

  // Puedes definir baseUrl aquí o recibirla como parámetro/constructor
  static const String baseUrl = 'http://$ipLocal/$pathHost/compra_combustible';

  Future<Map<String, List<ReporteItem>>> getReporteMensual() async {
    final res = await _api.getRequest('$baseUrl/get_reporte_mensual.php');

    final jsonData = json.decode(res);

    // print(res);

    if (jsonData['success'] != true) {
      throw Exception('Error en el servidor: ${jsonData['message']}');
    }

    final data = jsonData['data'];

    List<ReporteItem> data1 = (data['data1'] as List)
        .map((item) => ReporteItem.fromJson(item))
        .toList();

    List<ReporteItem> data2 = (data['data2'] as List)
        .map((item) => ReporteItem.fromJson(item))
        .toList();

    List<ReporteItem> data3 = (data['data3'] as List)
        .map((item) => ReporteItem.fromJson(item))
        .toList();

    return {
      'data1': data1,
      'data2': data2,
      'data3': data3,
    };
  }
}
