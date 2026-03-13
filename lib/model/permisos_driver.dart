// To parse this JSON data, do
//
//     final permisoDriver = permisoDriverFromJson(jsonString?);

import 'dart:convert';

List<PermisoDriver> permisoDriverFromJson(String str) =>
    List<PermisoDriver>.from(
        json.decode(str).map((x) => PermisoDriver.fromJson(x)));

String? permisoDriverToJson(List<PermisoDriver> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PermisoDriver {
  final String? permisoId;
  final String? usuarioId;
  final String? usuario;
  final String? nombreCompleto;
  final String? tipo;
  final String? fecha;
  final String? horaInicio;
  final String? horaFin;
  final String? fechaInicio;
  final String? fechaFin;
  final String? horasCalculadas;
  final String? diasCalculados;
  final String? motivo;
  final String? estado;
  final String? creadoEn;
  final String? actualizadoEn;

  PermisoDriver({
    this.permisoId,
    this.usuarioId,
    this.usuario,
    this.nombreCompleto,
    this.tipo,
    this.fecha,
    this.horaInicio,
    this.horaFin,
    this.fechaInicio,
    this.fechaFin,
    this.horasCalculadas,
    this.diasCalculados,
    this.motivo,
    this.estado,
    this.creadoEn,
    this.actualizadoEn,
  });

  /// Método copyWith
  PermisoDriver copyWith({
    String? permisoId,
    String? usuarioId,
    String? usuario,
    String? nombreCompleto,
    String? tipo,
    String? fecha,
    String? horaInicio,
    String? horaFin,
    String? fechaInicio,
    String? fechaFin,
    String? horasCalculadas,
    String? diasCalculados,
    String? motivo,
    String? estado,
    String? creadoEn,
    String? actualizadoEn,
  }) {
    return PermisoDriver(
      permisoId: permisoId ?? this.permisoId,
      usuarioId: usuarioId ?? this.usuarioId,
      usuario: usuario ?? this.usuario,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      horasCalculadas: horasCalculadas ?? this.horasCalculadas,
      diasCalculados: diasCalculados ?? this.diasCalculados,
      motivo: motivo ?? this.motivo,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }



  factory PermisoDriver.fromJson(Map<String?, dynamic> json) => PermisoDriver(
        permisoId: json["permiso_id"],
        usuarioId: json["usuario_id"],
        usuario: json["usuario"],
        nombreCompleto: json["nombre_completo"],
        tipo: json["tipo"],
        fecha: json["fecha"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        fechaInicio: json["fecha_inicio"],
        fechaFin: json["fecha_fin"],
        horasCalculadas: json["horas_calculadas"],
        diasCalculados: json["dias_calculados"],
        motivo: json["motivo"],
        estado: json["estado"],
        creadoEn: json["creado_en"],
        actualizadoEn: json["actualizado_en"],
      );

  Map<String?, dynamic> toJson() => {
        "permiso_id": permisoId,
        "usuario_id": usuarioId,
        "usuario": usuario,
        "nombre_completo": nombreCompleto,
        "tipo": tipo,
        "fecha": fecha,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "horas_calculadas": horasCalculadas,
        "dias_calculados": diasCalculados,
        "motivo": motivo,
        "estado": estado,
        "creado_en": creadoEn,
        "actualizado_en": actualizadoEn,
      };
  bool get isFinalizado => estado == 'finalizado';
}
