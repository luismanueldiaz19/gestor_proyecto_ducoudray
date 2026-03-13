// To parse this JSON data, do
//
//     final kpiCompras = kpiComprasFromJson(jsonString);

import 'dart:convert';

KpiCompras kpiComprasFromJson(String str) =>
    KpiCompras.fromJson(json.decode(str));

String kpiComprasToJson(KpiCompras data) => json.encode(data.toJson());

class KpiCompras {
  final bool? success;
  final String? totalGastado;
  final String? totalCompras;
  final String? totalProductos;
  final String? totalItems;
  final String? compraPromedio;
  final List<PorVehiculo>? porVehiculo;
  final List<PorProveedor>? porProveedor;
  final List<TopProducto>? topProductos;

  KpiCompras({
    this.success,
    this.totalGastado,
    this.totalCompras,
    this.totalProductos,
    this.totalItems,
    this.compraPromedio,
    this.porVehiculo,
    this.porProveedor,
    this.topProductos,
  });

  KpiCompras copyWith({
    bool? success,
    String? totalGastado,
    String? totalCompras,
    String? totalProductos,
    String? totalItems,
    String? compraPromedio,
    List<PorVehiculo>? porVehiculo,
    List<PorProveedor>? porProveedor,
    List<TopProducto>? topProductos,
  }) =>
      KpiCompras(
        success: success ?? this.success,
        totalGastado: totalGastado ?? this.totalGastado,
        totalCompras: totalCompras ?? this.totalCompras,
        totalProductos: totalProductos ?? this.totalProductos,
        totalItems: totalItems ?? this.totalItems,
        compraPromedio: compraPromedio ?? this.compraPromedio,
        porVehiculo: porVehiculo ?? this.porVehiculo,
        porProveedor: porProveedor ?? this.porProveedor,
        topProductos: topProductos ?? this.topProductos,
      );

  factory KpiCompras.fromJson(Map<String, dynamic> json) => KpiCompras(
        success: json["success"],
        totalGastado: json["total_gastado"],
        totalCompras: json["total_compras"],
        totalProductos: json["total_productos"],
        totalItems: json["total_items"],
        compraPromedio: json["compra_promedio"],
        porVehiculo: json["por_vehiculo"] == null
            ? []
            : List<PorVehiculo>.from(
                json["por_vehiculo"]!.map((x) => PorVehiculo.fromJson(x))),
        porProveedor: json["por_proveedor"] == null
            ? []
            : List<PorProveedor>.from(
                json["por_proveedor"]!.map((x) => PorProveedor.fromJson(x))),
        topProductos: json["top_productos"] == null
            ? []
            : List<TopProducto>.from(
                json["top_productos"]!.map((x) => TopProducto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "total_gastado": totalGastado,
        "total_compras": totalCompras,
        "total_productos": totalProductos,
        "total_items": totalItems,
        "compra_promedio": compraPromedio,
        "por_vehiculo": porVehiculo == null
            ? []
            : List<dynamic>.from(porVehiculo!.map((x) => x.toJson())),
        "por_proveedor": porProveedor == null
            ? []
            : List<dynamic>.from(porProveedor!.map((x) => x.toJson())),
        "top_productos": topProductos == null
            ? []
            : List<dynamic>.from(topProductos!.map((x) => x.toJson())),
      };
}

class PorProveedor {
  final String? proveedor;
  final String? totalGastado;

  PorProveedor({
    this.proveedor,
    this.totalGastado,
  });

  PorProveedor copyWith({
    String? proveedor,
    String? totalGastado,
  }) =>
      PorProveedor(
        proveedor: proveedor ?? this.proveedor,
        totalGastado: totalGastado ?? this.totalGastado,
      );

  factory PorProveedor.fromJson(Map<String, dynamic> json) => PorProveedor(
        proveedor: json["proveedor"],
        totalGastado: json["total_gastado"],
      );

  Map<String, dynamic> toJson() => {
        "proveedor": proveedor,
        "total_gastado": totalGastado,
      };
}

class PorVehiculo {
  final String? idVehiculo;
  final String? ficha;
  final String? totalGastado;

  PorVehiculo({
    this.idVehiculo,
    this.ficha,
    this.totalGastado,
  });

  PorVehiculo copyWith({
    String? idVehiculo,
    String? ficha,
    String? totalGastado,
  }) =>
      PorVehiculo(
        idVehiculo: idVehiculo ?? this.idVehiculo,
        ficha: ficha ?? this.ficha,
        totalGastado: totalGastado ?? this.totalGastado,
      );

  factory PorVehiculo.fromJson(Map<String, dynamic> json) => PorVehiculo(
        idVehiculo: json["id_vehiculo"],
        ficha: json["ficha"],
        totalGastado: json["total_gastado"],
      );

  Map<String, dynamic> toJson() => {
        "id_vehiculo": idVehiculo,
        "ficha": ficha,
        "total_gastado": totalGastado,
      };
}

class TopProducto {
  final String? producto;
  final String? cantidadComprada;
  final String? totalGastado;

  TopProducto({
    this.producto,
    this.cantidadComprada,
    this.totalGastado,
  });

  TopProducto copyWith({
    String? producto,
    String? cantidadComprada,
    String? totalGastado,
  }) =>
      TopProducto(
        producto: producto ?? this.producto,
        cantidadComprada: cantidadComprada ?? this.cantidadComprada,
        totalGastado: totalGastado ?? this.totalGastado,
      );

  factory TopProducto.fromJson(Map<String, dynamic> json) => TopProducto(
        producto: json["producto"],
        cantidadComprada: json["cantidad_comprada"],
        totalGastado: json["total_gastado"],
      );

  Map<String, dynamic> toJson() => {
        "producto": producto,
        "cantidad_comprada": cantidadComprada,
        "total_gastado": totalGastado,
      };
}
