// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);

import 'dart:convert';

List<Proveedor> proveedorFromJson(String str) =>
    List<Proveedor>.from(json.decode(str).map((x) => Proveedor.fromJson(x)));

String proveedorToJson(List<Proveedor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proveedor {
  final String? idProveedor;
  final String? nombreProveedor;
  final String? rnc;
  final String? telefono;
  final String? correo;
  final String? direccion;
  final String? tipoProveedor;
  final String? registradoPor;
  final String? fechaRegistro;
  final String? statu;

  Proveedor({
    this.idProveedor,
    this.nombreProveedor,
    this.rnc,
    this.telefono,
    this.correo,
    this.direccion,
    this.tipoProveedor,
    this.registradoPor,
    this.fechaRegistro,
    this.statu,
  });

  Proveedor copyWith({
    String? idProveedor,
    String? nombreProveedor,
    String? rnc,
    String? telefono,
    String? correo,
    String? direccion,
    String? tipoProveedor,
    String? registradoPor,
    String? fechaRegistro,
    String? statu,
  }) =>
      Proveedor(
        idProveedor: idProveedor ?? this.idProveedor,
        nombreProveedor: nombreProveedor ?? this.nombreProveedor,
        rnc: rnc ?? this.rnc,
        telefono: telefono ?? this.telefono,
        correo: correo ?? this.correo,
        direccion: direccion ?? this.direccion,
        tipoProveedor: tipoProveedor ?? this.tipoProveedor,
        registradoPor: registradoPor ?? this.registradoPor,
        fechaRegistro: fechaRegistro ?? this.fechaRegistro,
        statu: statu ?? this.statu,
      );

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        idProveedor: json["id_proveedor"],
        nombreProveedor: json["nombre_proveedor"],
        rnc: json["rnc"] ?? 'N/A',
        telefono: json["telefono"] ?? 'N/A',
        correo: json["correo"] ?? 'N/A',
        direccion: json["direccion"] ?? 'N/A',
        tipoProveedor: json["tipo_proveedor"],
        registradoPor: json["registrado_por"],
        fechaRegistro: json["fecha_registro"],
        statu: json["statu"],
      );

  Map<String, dynamic> toJson() => {
        "id_proveedor": idProveedor,
        "nombre_proveedor": nombreProveedor,
        "rnc": rnc,
        "telefono": telefono,
        "correo": correo,
        "direccion": direccion,
        "tipo_proveedor": tipoProveedor,
        "registrado_por": registradoPor,
        "fecha_registro": fechaRegistro,
        "statu": statu,
      };
}
