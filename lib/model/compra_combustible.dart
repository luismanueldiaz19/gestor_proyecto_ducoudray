import 'dart:convert';

import 'item_combustible.dart';

List<CompraCombustible> compraCombustibleFromJson(String str) =>
    List<CompraCombustible>.from(
        json.decode(str).map((x) => CompraCombustible.fromJson(x)));

class CompraCombustible {
  final int? compraCombustibleId;
  final String? proveedor;
  final String? numeroFactura;
  final String? fecha;
  final String? registradoPor;
  final List<ItemCombustible>? items; // hijos

  CompraCombustible({
    this.compraCombustibleId,
    this.proveedor,
    this.numeroFactura,
    this.fecha,
    this.registradoPor,
    this.items,
  });

  factory CompraCombustible.fromJson(Map<String, dynamic> json) {
    return CompraCombustible(
      compraCombustibleId: json['compra_combustible_id'],
      proveedor: json['proveedor'],
      numeroFactura: json['numero_factura'],
      fecha: json['fecha'],
      registradoPor: json['registrado_por'],
      items: json['items'] != null
          ? List<ItemCombustible>.from(
              json['items'].map((x) => ItemCombustible.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compra_combustible_id': compraCombustibleId,
      'proveedor': proveedor,
      'numero_factura': numeroFactura,
      'fecha': fecha,
      'registrado_por': registradoPor,
      'items': items?.map((x) => x.toJson()).toList(),
    };
  }

  static String getTotalCant(List<CompraCombustible> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      for (var item in element.items!) {
        totalOrden += calcularSubtotal(item.cantidad, item.precioPorCantidad);
      }
    }

    return totalOrden.toStringAsFixed(2);
  }

  static double calcularSubtotal(double? cantidad, double? precio) {
    if (cantidad == null || precio == null || cantidad < 0 || precio < 0) {
      return 0.0;
    }
    return cantidad * precio;
  }
}
