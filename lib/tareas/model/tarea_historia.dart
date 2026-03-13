// To parse this JSON data, do
//
//     final tareaHistoria = tareaHistoriaFromJson(jsonString);

import 'dart:convert';

List<TareaHistoria> tareaHistoriaFromJson(String str) =>
    List<TareaHistoria>.from(
        json.decode(str).map((x) => TareaHistoria.fromJson(x)));

String tareaHistoriaToJson(List<TareaHistoria> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TareaHistoria {
  final String? estado;
  final String? tareaId;
  final String? titulo;
  final String? hechoPor;
  final double? horas;
  final String? descripcion;
  final String? creadoEn;
  final String? feedback;
  final String? registedBy;

  TareaHistoria({
    this.estado,
    this.tareaId,
    this.titulo,
    this.hechoPor,
    this.horas,
    this.creadoEn,
    this.descripcion,
    this.feedback,
    this.registedBy,
  });

  TareaHistoria copyWith({
    String? estado,
    String? tareaId,
    String? titulo,
    String? hechoPor,
    double? horas,
    String? creadoEn,
    String? descripcion,
    String? feedback,
    String? registedBy,
  }) =>
      TareaHistoria(
        estado: estado ?? this.estado,
        tareaId: tareaId ?? this.tareaId,
        titulo: titulo ?? this.titulo,
        hechoPor: hechoPor ?? this.hechoPor,
        horas: horas ?? this.horas,
        creadoEn: creadoEn ?? this.creadoEn,
        descripcion: descripcion ?? this.descripcion,
        feedback: feedback ?? this.feedback,
        registedBy: registedBy ?? this.registedBy,
      );

  factory TareaHistoria.fromJson(Map<String, dynamic> json) => TareaHistoria(
      estado: json["estado"],
      tareaId: json["tarea_id"],
      titulo: json["titulo"],
      hechoPor: json["hecho_por"],
      horas: json["horas"]?.toDouble(),
      creadoEn: json["creado_en"],
      descripcion: json['descripcion'],
      feedback: json['feedback'],
      registedBy: json['registed_by']);

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "tarea_id": tareaId,
        "titulo": titulo,
        "hecho_por": hechoPor,
        "horas": horas,
        "creado_en": creadoEn,
        "descripcion": descripcion,
        "feedback": feedback,
        "registed_by": registedBy,
      };
 

  static List<String> getUniqueTitulos(List<TareaHistoria> list) {
    return list.map((element) => element.titulo!).toSet().toList();
  }

  static List<String> getUniqueUsuario(List<TareaHistoria> list) {
    return list.map((element) => element.hechoPor!).toSet().toList();
  }

  static List<String> getUniqueFecha(List<TareaHistoria> list) {
    return list
        .map((element) => element.creadoEn!.toString().substring(0, 10))
        .toSet()
        .toList();
  }
}
