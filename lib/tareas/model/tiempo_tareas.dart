// To parse this JSON data, do
//
//     final tiempoTarea = tiempoTareaFromJson(jsonString);

import 'dart:convert';

List<TiempoTarea> tiempoTareaFromJson(String str) => List<TiempoTarea>.from(
    json.decode(str).map((x) => TiempoTarea.fromJson(x)));

String tiempoTareaToJson(List<TiempoTarea> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TiempoTarea {
  final String? tiempoId;
  final String? tareaId;
  final String? inicio;
  final String? fin;
  final double? horas;

  TiempoTarea({
    this.tiempoId,
    this.tareaId,
    this.inicio,
    this.fin,
    this.horas,
  });

  TiempoTarea copyWith({
    String? tiempoId,
    String? tareaId,
    String? inicio,
    String? fin,
    double? horas,
  }) =>
      TiempoTarea(
        tiempoId: tiempoId ?? this.tiempoId,
        tareaId: tareaId ?? this.tareaId,
        inicio: inicio ?? this.inicio,
        fin: fin ?? this.fin,
        horas: horas ?? this.horas,
      );

  factory TiempoTarea.fromJson(Map<String, dynamic> json) => TiempoTarea(
        tiempoId: json["tiempo_id"],
        tareaId: json["tarea_id"],
        inicio: json["inicio"],
        fin: json["fin"],
        horas: json["horas"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "tiempo_id": tiempoId,
        "tarea_id": tareaId,
        "inicio": inicio,
        "fin": fin,
        "horas": horas,
      };
}
