// To parse this JSON data, do
//
//     final resumenGastoCompra = resumenGastoCompraFromJson(jsonString);

import 'dart:convert';

List<ResumenGastoCompra> resumenGastoCompraFromJson(String str) =>
    List<ResumenGastoCompra>.from(
        json.decode(str).map((x) => ResumenGastoCompra.fromJson(x)));

String resumenGastoCompraToJson(List<ResumenGastoCompra> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResumenGastoCompra {
  final String mes;
  final String fechaMes;
  final String gastoTotal;
  final String compraTotal;
  final String vehiculosIntervenidos;

  ResumenGastoCompra({
    required this.mes,
    required this.fechaMes,
    required this.gastoTotal,
    required this.compraTotal,
    required this.vehiculosIntervenidos,
  });

  ResumenGastoCompra copyWith({
    String? mes,
    String? fechaMes,
    String? gastoTotal,
    String? compraTotal,
    String? vehiculosIntervenidos,
  }) =>
      ResumenGastoCompra(
        mes: mes ?? this.mes,
        fechaMes: fechaMes ?? this.fechaMes,
        gastoTotal: gastoTotal ?? this.gastoTotal,
        compraTotal: compraTotal ?? this.compraTotal,
        vehiculosIntervenidos:
            vehiculosIntervenidos ?? this.vehiculosIntervenidos,
      );

  factory ResumenGastoCompra.fromJson(Map<String, dynamic> json) =>
      ResumenGastoCompra(
        mes: json["mes"],
        fechaMes: json["fecha_mes"],
        gastoTotal: json["gasto_total"],
        compraTotal: json["compra_total"],
        vehiculosIntervenidos: json["vehiculos_intervenidos"],
      );

  Map<String, dynamic> toJson() => {
        "mes": mes,
        "fecha_mes": fechaMes,
        "gasto_total": gastoTotal,
        "compra_total": compraTotal,
        "vehiculos_intervenidos": vehiculosIntervenidos,
      };
}
