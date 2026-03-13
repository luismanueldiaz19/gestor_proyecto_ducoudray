// To parse this JSON data, do
//
//     final incapacidaUsuario = incapacidaUsuarioFromJson(jsonString);

import 'dart:convert';

List<IncapacidaUsuario> incapacidaUsuarioFromJson(String str) =>
    List<IncapacidaUsuario>.from(
        json.decode(str).map((x) => IncapacidaUsuario.fromJson(x)));

String incapacidaUsuarioToJson(List<IncapacidaUsuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncapacidaUsuario {
  final String? usuarioId;
  final String? usuario;
  final String? nombreCompleto;
  final String? status;
  final String? occupacion;
  final String? fechaIngreso;
  final String? fechaVacaciones;
  final String? incapacidadId;
  final String? tipo;
  final String? fechaInicio;
  final String? fechaFin;
  final String? diasCalculados;
  final String? descripcion;
  final String? documentoUrl;
  final String? estado;
  final String? creadoEn;
  final String? actualizadoEn;

  IncapacidaUsuario({
    this.usuarioId,
    this.usuario,
    this.nombreCompleto,
    this.status,
    this.occupacion,
    this.fechaIngreso,
    this.fechaVacaciones,
    this.incapacidadId,
    this.tipo,
    this.fechaInicio,
    this.fechaFin,
    this.diasCalculados,
    this.descripcion,
    this.documentoUrl,
    this.estado,
    this.creadoEn,
    this.actualizadoEn,
  });

  IncapacidaUsuario copyWith({
    String? usuarioId,
    String? usuario,
    String? nombreCompleto,
    String? status,
    String? occupacion,
    String? fechaIngreso,
    String? fechaVacaciones,
    String? incapacidadId,
    String? tipo,
    String? fechaInicio,
    String? fechaFin,
    String? diasCalculados,
    String? descripcion,
    String? documentoUrl,
    String? estado,
    String? creadoEn,
    String? actualizadoEn,
  }) =>
      IncapacidaUsuario(
        usuarioId: usuarioId ?? this.usuarioId,
        usuario: usuario ?? this.usuario,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        status: status ?? this.status,
        occupacion: occupacion ?? this.occupacion,
        fechaIngreso: fechaIngreso ?? this.fechaIngreso,
        fechaVacaciones: fechaVacaciones ?? this.fechaVacaciones,
        incapacidadId: incapacidadId ?? this.incapacidadId,
        tipo: tipo ?? this.tipo,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
        diasCalculados: diasCalculados ?? this.diasCalculados,
        descripcion: descripcion ?? this.descripcion,
        documentoUrl: documentoUrl ?? this.documentoUrl,
        estado: estado ?? this.estado,
        creadoEn: creadoEn ?? this.creadoEn,
        actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      );

  factory IncapacidaUsuario.fromJson(Map<String, dynamic> json) =>
      IncapacidaUsuario(
        usuarioId: json["usuario_id"],
        usuario: json["usuario"],
        nombreCompleto: json["nombre_completo"],
        status: json["status"],
        occupacion: json["occupacion"],
        fechaIngreso: json["fecha_ingreso"],
        fechaVacaciones: json["fecha_vacaciones"],
        incapacidadId: json["incapacidad_id"],
        tipo: json["tipo"],
        fechaInicio: json["fecha_inicio"],
        fechaFin: json["fecha_fin"],
        diasCalculados: json["dias_calculados"],
        descripcion: json["descripcion"],
        documentoUrl: json["documento_url"],
        estado: json["estado"],
        creadoEn: json["creado_en"],
        actualizadoEn: json["actualizado_en"],
      );

  Map<String, dynamic> toJson() => {
        "usuario_id": usuarioId,
        "usuario": usuario,
        "nombre_completo": nombreCompleto,
        "status": status,
        "occupacion": occupacion,
        "fecha_ingreso": fechaIngreso,
        "fecha_vacaciones": fechaVacaciones,
        "incapacidad_id": incapacidadId,
        "tipo": tipo,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "dias_calculados": diasCalculados,
        "descripcion": descripcion,
        "documento_url": documentoUrl,
        "estado": estado,
        "creado_en": creadoEn,
        "actualizado_en": actualizadoEn,
      };

      bool get isFinalizado => estado == 'finalizado';
}
