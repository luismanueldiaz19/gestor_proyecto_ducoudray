// To parse this JSON data, do
//
//     final vacaciones = vacacionesFromJson(jsonString);

import 'dart:convert';

List<Vacaciones> vacacionesFromJson(String str) =>
    List<Vacaciones>.from(json.decode(str).map((x) => Vacaciones.fromJson(x)));

String vacacionesToJson(List<Vacaciones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vacaciones {
  final String? usuarioId;
  final String? usuario;
  final String? nombreCompleto;
  final String? status;
  final String? occupacion;
  final String? fechaIngreso;
  final String? fechaVacaciones;
  final String? vacacionId;
  final String? fechaInicio;
  final String? fechaFin;
  final String? diasCalculados;
  final String? motivo;
  final String? estado;
  final String? monto;
  final String? creadoEn;
  final String? actualizadoEn;

  Vacaciones({
    this.usuarioId,
    this.usuario,
    this.nombreCompleto,
    this.status,
    this.occupacion,
    this.fechaIngreso,
    this.fechaVacaciones,
    this.vacacionId,
    this.fechaInicio,
    this.fechaFin,
    this.diasCalculados,
    this.motivo,
    this.estado,
    this.monto,
    this.creadoEn,
    this.actualizadoEn,
  });

  /// Método copyWith para clonar y modificar campos
  Vacaciones copyWith({
    String? usuarioId,
    String? usuario,
    String? nombreCompleto,
    String? status,
    String? occupacion,
    String? fechaIngreso,
    String? fechaVacaciones,
    String? vacacionId,
    String? fechaInicio,
    String? fechaFin,
    String? diasCalculados,
    String? motivo,
    String? estado,
    String? monto,
    String? creadoEn,
    String? actualizadoEn,
  }) {
    return Vacaciones(
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      status: status ?? this.status,
      occupacion: occupacion ?? this.occupacion,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaVacaciones: fechaVacaciones ?? this.fechaVacaciones,
      vacacionId: vacacionId ?? this.vacacionId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      diasCalculados: diasCalculados ?? this.diasCalculados,
      motivo: motivo ?? this.motivo,
      estado: estado ?? this.estado,
      monto: monto ?? this.monto,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  bool get isFinalizado => estado == 'finalizado';

  factory Vacaciones.fromJson(Map<String, dynamic> json) => Vacaciones(
        usuarioId: json["usuario_id"],
        usuario: json["usuario"],
        nombreCompleto: json["nombre_completo"],
        status: json["status"],
        occupacion: json["occupacion"],
        fechaIngreso: json["fecha_ingreso"],
        fechaVacaciones: json["fecha_vacaciones"],
        vacacionId: json["vacacion_id"],
        fechaInicio: json["fecha_inicio"],
        fechaFin: json["fecha_fin"],
        diasCalculados: json["dias_calculados"],
        monto: json["monto"],
        motivo: json["motivo"],
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
        "vacacion_id": vacacionId,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "dias_calculados": diasCalculados,
        "monto": monto,
        "motivo": motivo,
        "estado": estado,
        "creado_en": creadoEn,
        "actualizado_en": actualizadoEn,
      };
}
