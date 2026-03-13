// To parse this JSON data, do
//
//     final kpiGasto = kpiGastoFromJson(jsonString);

import 'dart:convert';

KpiGasto kpiGastoFromJson(String str) => KpiGasto.fromJson(json.decode(str));

String kpiGastoToJson(KpiGasto data) => json.encode(data.toJson());

class KpiGasto {
  final double? totalGastado;
  final int? cantidadGastos;
  final double? gastoPromedio;
  final List<PorVehiculo>? porVehiculo;
  final List<PorTipoGasto>? porTipoGasto;
  final List<TopConcepto>? topConceptos;
  final List<PorProveedor>? porProveedor;

  KpiGasto({
    this.totalGastado,
    this.cantidadGastos,
    this.gastoPromedio,
    this.porVehiculo,
    this.porTipoGasto,
    this.topConceptos,
    this.porProveedor,
  });

  KpiGasto copyWith({
    double? totalGastado,
    int? cantidadGastos,
    double? gastoPromedio,
    List<PorVehiculo>? porVehiculo,
    List<PorTipoGasto>? porTipoGasto,
    List<TopConcepto>? topConceptos,
    List<PorProveedor>? porProveedor,
  }) =>
      KpiGasto(
        totalGastado: totalGastado ?? this.totalGastado,
        cantidadGastos: cantidadGastos ?? this.cantidadGastos,
        gastoPromedio: gastoPromedio ?? this.gastoPromedio,
        porVehiculo: porVehiculo ?? this.porVehiculo,
        porTipoGasto: porTipoGasto ?? this.porTipoGasto,
        topConceptos: topConceptos ?? this.topConceptos,
        porProveedor: porProveedor ?? this.porProveedor,
      );

  factory KpiGasto.fromJson(Map<String, dynamic> json) => KpiGasto(
        totalGastado: json["total_gastado"]?.toDouble(),
        cantidadGastos: json["cantidad_gastos"],
        gastoPromedio: json["gasto_promedio"]?.toDouble(),
        porVehiculo: json["por_vehiculo"] == null
            ? []
            : List<PorVehiculo>.from(
                json["por_vehiculo"]!.map((x) => PorVehiculo.fromJson(x))),
        porTipoGasto: json["por_tipo_gasto"] == null
            ? []
            : List<PorTipoGasto>.from(
                json["por_tipo_gasto"]!.map((x) => PorTipoGasto.fromJson(x))),
        topConceptos: json["top_conceptos"] == null
            ? []
            : List<TopConcepto>.from(
                json["top_conceptos"]!.map((x) => TopConcepto.fromJson(x))),
        porProveedor: json["por_proveedor"] == null
            ? []
            : List<PorProveedor>.from(
                json["por_proveedor"]!.map((x) => PorProveedor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_gastado": totalGastado,
        "cantidad_gastos": cantidadGastos,
        "gasto_promedio": gastoPromedio,
        "por_vehiculo": porVehiculo == null
            ? []
            : List<dynamic>.from(porVehiculo!.map((x) => x.toJson())),
        "por_tipo_gasto": porTipoGasto == null
            ? []
            : List<dynamic>.from(porTipoGasto!.map((x) => x.toJson())),
        "top_conceptos": topConceptos == null
            ? []
            : List<dynamic>.from(topConceptos!.map((x) => x.toJson())),
        "por_proveedor": porProveedor == null
            ? []
            : List<dynamic>.from(porProveedor!.map((x) => x.toJson())),
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

class PorTipoGasto {
  final String? tipoGasto;
  final String? totalGastado;

  PorTipoGasto({
    this.tipoGasto,
    this.totalGastado,
  });

  PorTipoGasto copyWith({
    String? tipoGasto,
    String? totalGastado,
  }) =>
      PorTipoGasto(
        tipoGasto: tipoGasto ?? this.tipoGasto,
        totalGastado: totalGastado ?? this.totalGastado,
      );

  factory PorTipoGasto.fromJson(Map<String, dynamic> json) => PorTipoGasto(
        tipoGasto: json["tipo_gasto"],
        totalGastado: json["total_gastado"],
      );

  Map<String, dynamic> toJson() => {
        "tipo_gasto": tipoGasto,
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

class TopConcepto {
  final String? concepto;
  final String? totalGastado;

  TopConcepto({
    this.concepto,
    this.totalGastado,
  });

  TopConcepto copyWith({
    String? concepto,
    String? totalGastado,
  }) =>
      TopConcepto(
        concepto: concepto ?? this.concepto,
        totalGastado: totalGastado ?? this.totalGastado,
      );

  factory TopConcepto.fromJson(Map<String, dynamic> json) => TopConcepto(
        concepto: json["concepto"],
        totalGastado: json["total_gastado"],
      );

  Map<String, dynamic> toJson() => {
        "concepto": concepto,
        "total_gastado": totalGastado,
      };
}
