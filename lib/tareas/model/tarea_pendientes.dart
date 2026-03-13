// To parse this JSON data, do
//
//     final tareaPendiente = tareaPendienteFromJson(jsonString);

import 'dart:convert';

List<TareaPendiente> tareaPendienteFromJson(String str) =>
    List<TareaPendiente>.from(
        json.decode(str).map((x) => TareaPendiente.fromJson(x)));

String tareaPendienteToJson(List<TareaPendiente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TareaPendiente {
  final String? estado;
  final String? tareaId;
  final String? titulo;
  final String? hechoPor;
  final double? horas;
  final String? descripcion;
  final bool? tiempoAbierto;
  final String? creadoEn;
  final String? feedback;
  final String? registedBy;

  TareaPendiente({
    this.estado,
    this.tareaId,
    this.titulo,
    this.hechoPor,
    this.horas,
    this.descripcion,
    this.tiempoAbierto,
    this.creadoEn,
    this.feedback,
    this.registedBy,
  });

  TareaPendiente copyWith({
    String? estado,
    String? tareaId,
    String? titulo,
    String? hechoPor,
    double? horas,
    bool? tiempoAbierto,
    String? descripcion,
    String? creadoEn,
    String? feedback,
    String? registedBy,
  }) =>
      TareaPendiente(
        estado: estado ?? this.estado,
        tareaId: tareaId ?? this.tareaId,
        titulo: titulo ?? this.titulo,
        hechoPor: hechoPor ?? this.hechoPor,
        horas: horas ?? this.horas,
        tiempoAbierto: tiempoAbierto ?? this.tiempoAbierto,
        descripcion: descripcion ?? this.descripcion,
        creadoEn: creadoEn ?? this.creadoEn,
        feedback: feedback ?? this.feedback,
        registedBy: registedBy ?? this.registedBy,
      );

  factory TareaPendiente.fromJson(Map<String, dynamic> json) => TareaPendiente(
      estado: json["estado"],
      tareaId: json["tarea_id"],
      titulo: json["titulo"],
      hechoPor: json["hecho_por"],
      horas: json["horas"]?.toDouble(),
      tiempoAbierto: json["tiempo_abierto"],
      descripcion: json['descripcion'],
      creadoEn: json['creado_en'],
      feedback: json['feedback'],
      registedBy: json['registed_by']);

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "tarea_id": tareaId,
        "titulo": titulo,
        "hecho_por": hechoPor,
        "horas": horas,
        "tiempo_abierto": tiempoAbierto,
        "descripcion": descripcion,
        "creado_en": creadoEn,
        "feedback": feedback,
        "registed_by": registedBy,
      };

  String get hasTiempo => tiempoAbierto == false
      ? 'Tiempo Cerrado'.toUpperCase()
      : 'Tiempo Abierto'.toUpperCase();

  

  static List<String> getUniqueTitulos(List<TareaPendiente> list) {
    return list.map((element) => element.titulo!).toSet().toList();
  }

  static List<String> getUniqueUsuario(List<TareaPendiente> list) {
    return list.map((element) => element.hechoPor!).toSet().toList();
  }

  static List<String> getUniqueFecha(List<TareaPendiente> list) {
    return list
        .map((element) => element.creadoEn!.toString().substring(0, 10))
        .toSet()
        .toList();
  }
}
