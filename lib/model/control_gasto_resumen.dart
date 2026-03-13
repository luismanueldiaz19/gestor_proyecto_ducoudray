// To parse this JSON data, do
//
//     final controlGastoResumen = controlGastoResumenFromJson(jsonString);

import 'dart:convert';

List<ControlGastoResumen> controlGastoResumenFromJson(String str) =>
    List<ControlGastoResumen>.from(
        json.decode(str).map((x) => ControlGastoResumen.fromJson(x)));

String controlGastoResumenToJson(List<ControlGastoResumen> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ControlGastoResumen {
  final String recurso;
  final String mesIndex;
  final String mesNombre;
  final String totalMensual;

  ControlGastoResumen({
    required this.recurso,
    required this.mesIndex,
    required this.mesNombre,
    required this.totalMensual,
  });

  ControlGastoResumen copyWith({
    String? recurso,
    String? mesIndex,
    String? mesNombre,
    String? totalMensual,
  }) =>
      ControlGastoResumen(
        recurso: recurso ?? this.recurso,
        mesIndex: mesIndex ?? this.mesIndex,
        mesNombre: mesNombre ?? this.mesNombre,
        totalMensual: totalMensual ?? this.totalMensual,
      );

  factory ControlGastoResumen.fromJson(Map<String, dynamic> json) =>
      ControlGastoResumen(
        recurso: json["recurso"],
        mesIndex: json["mes_index"],
        mesNombre: json["mes_nombre"],
        totalMensual: json["total_mensual"],
      );

  Map<String, dynamic> toJson() => {
        "recurso": recurso,
        "mes_index": mesIndex,
        "mes_nombre": mesNombre,
        "total_mensual": totalMensual,
      };

  static String getTotal(List<ControlGastoResumen> collection) {
    final total = collection.fold<num>(
      0,
      (sum, caja) => sum + (double.tryParse(caja.totalMensual) ?? 0),
    );
    return total.toStringAsFixed(0);
  }
}

List<CombustibleResumen> combustibleResumenFromJson(String str) =>
    List<CombustibleResumen>.from(
        json.decode(str).map((x) => CombustibleResumen.fromJson(x)));

String combustibleResumenToJson(List<CombustibleResumen> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CombustibleResumen {
  final String? idVehiculo;
  final String? marca;
  final String? ficha;
  final int? mesIndex;
  final String? mesNombre;
  final double? gastoMensual;
  final double? galonesMensual;

  CombustibleResumen({
    this.idVehiculo,
    this.marca,
    this.ficha,
    this.mesIndex,
    this.mesNombre,
    this.gastoMensual,
    this.galonesMensual,
  });

  factory CombustibleResumen.fromJson(Map<String, dynamic> json) =>
      CombustibleResumen(
        idVehiculo: json["id_vehiculo"] ?? 'N/A',
        marca: json["marca"] ?? 'N/A',
        ficha: json["ficha"] ?? 'N/A',
        mesIndex: int.tryParse(json["mes_index"]) ?? 0,
        mesNombre: json["mes_nombre"] ?? 'N/A',
        gastoMensual: double.tryParse(json["gasto_mensual"]) ?? 0.0,
        galonesMensual: double.tryParse(json["galones_mensual"]) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id_vehiculo": idVehiculo,
        "marca": marca,
        "ficha": ficha,
        "mes_index": mesIndex,
        "mes_nombre": mesNombre,
        "gasto_mensual": gastoMensual,
        "galones_mensual": galonesMensual,
      };

  static String getTotalGalones(List<CombustibleResumen> collection) {
    final total = collection.fold<num>(
      0,
      (sum, caja) =>
          sum + (double.tryParse(caja.galonesMensual.toString()) ?? 0),
    );
    return total.toStringAsFixed(0);
  }

  static String getTotalMontocombustible(List<CombustibleResumen> collection) {
    final total = collection.fold<num>(
      0,
      (sum, caja) => sum + (double.tryParse(caja.gastoMensual.toString()) ?? 0),
    );
    return total.toStringAsFixed(0);
  }
}
