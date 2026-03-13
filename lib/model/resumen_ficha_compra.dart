// To parse this JSON data, do
//
//     final resumenFichaCompra = resumenFichaCompraFromJson(jsonString);

import 'dart:convert';

List<ResumenFichaCompra> resumenFichaCompraFromJson(String str) =>
    List<ResumenFichaCompra>.from(
        json.decode(str).map((x) => ResumenFichaCompra.fromJson(x)));

String resumenFichaCompraToJson(List<ResumenFichaCompra> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResumenFichaCompra {
  final String? idVehiculo;
  final String? ficha;
  final String? montoTotal;
  final String? compras;
  final String? totalProductos;
  final String? totalArticulos;
  final String? compraPromedio;

  ResumenFichaCompra({
    this.idVehiculo,
    this.ficha,
    this.montoTotal,
    this.compras,
    this.totalProductos,
    this.totalArticulos,
    this.compraPromedio,
  });

  ResumenFichaCompra copyWith({
    String? idVehiculo,
    String? ficha,
    String? montoTotal,
    String? compras,
    String? totalProductos,
    String? totalArticulos,
    String? compraPromedio,
  }) =>
      ResumenFichaCompra(
        idVehiculo: idVehiculo ?? this.idVehiculo,
        ficha: ficha ?? this.ficha,
        montoTotal: montoTotal ?? this.montoTotal,
        compras: compras ?? this.compras,
        totalProductos: totalProductos ?? this.totalProductos,
        totalArticulos: totalArticulos ?? this.totalArticulos,
        compraPromedio: compraPromedio ?? this.compraPromedio,
      );

  factory ResumenFichaCompra.fromJson(Map<String, dynamic> json) =>
      ResumenFichaCompra(
        idVehiculo: json["id_vehiculo"],
        ficha: json["ficha"],
        montoTotal: json["monto_total"],
        compras: json["compras"],
        totalProductos: json["total_productos"],
        totalArticulos: json["total_articulos"],
        compraPromedio: json["compra_promedio"],
      );

  Map<String, dynamic> toJson() => {
        "id_vehiculo": idVehiculo,
        "ficha": ficha,
        "monto_total": montoTotal,
        "compras": compras,
        "total_productos": totalProductos,
        "total_articulos": totalArticulos,
        "compra_promedio": compraPromedio,
      };
}
