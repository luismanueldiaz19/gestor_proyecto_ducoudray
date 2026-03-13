// To parse this JSON data, do
//
//     final incidenciaVehiculo = incidenciaVehiculoFromJson(jsonString);

import 'dart:convert';

List<IncidenciaVehiculo> incidenciaVehiculoFromJson(String str) =>
    List<IncidenciaVehiculo>.from(
        json.decode(str).map((x) => IncidenciaVehiculo.fromJson(x)));

String incidenciaVehiculoToJson(List<IncidenciaVehiculo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncidenciaVehiculo {
  final String? incidenciaVehiculoId;
  final String? registedBy;
  final String? idVehiculo;
  final String? marca;
  final String? placas;
  final String? ficha;
  final String? estadoIncidencia;
  final String? observaciones;
  final String? creadoEn;
  final List<Imagene>? imagenes;

  IncidenciaVehiculo({
    this.incidenciaVehiculoId,
    this.registedBy,
    this.idVehiculo,
    this.marca,
    this.placas,
    this.ficha,
    this.estadoIncidencia,
    this.observaciones,
    this.creadoEn,
    this.imagenes,
  });

  IncidenciaVehiculo copyWith({
    String? incidenciaVehiculoId,
    String? registedBy,
    String? idVehiculo,
    String? marca,
    String? placas,
    String? ficha,
    String? estadoIncidencia,
    String? observaciones,
    String? creadoEn,
    List<Imagene>? imagenes,
  }) =>
      IncidenciaVehiculo(
        incidenciaVehiculoId: incidenciaVehiculoId ?? this.incidenciaVehiculoId,
        registedBy: registedBy ?? this.registedBy,
        idVehiculo: idVehiculo ?? this.idVehiculo,
        marca: marca ?? this.marca,
        placas: placas ?? this.placas,
        ficha: ficha ?? this.ficha,
        estadoIncidencia: estadoIncidencia ?? this.estadoIncidencia,
        observaciones: observaciones ?? this.observaciones,
        creadoEn: creadoEn ?? this.creadoEn,
        imagenes: imagenes ?? this.imagenes,
      );

  factory IncidenciaVehiculo.fromJson(Map<String, dynamic> json) =>
      IncidenciaVehiculo(
        incidenciaVehiculoId: json["incidencia_vehiculo_id"],
        registedBy: json["registed_by"],
        idVehiculo: json["id_vehiculo"],
        marca: json["marca"],
        placas: json["placas"],
        ficha: json["ficha"],
        estadoIncidencia: json["estado_incidencia"],
        observaciones: json["observaciones"],
        creadoEn: json["creado_en"],
        imagenes: json["imagenes"] == null
            ? []
            : List<Imagene>.from(
                json["imagenes"]!.map((x) => Imagene.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "incidencia_vehiculo_id": incidenciaVehiculoId,
        "registed_by": registedBy,
        "id_vehiculo": idVehiculo,
        "marca": marca,
        "placas": placas,
        "ficha": ficha,
        "estado_incidencia": estadoIncidencia,
        "observaciones": observaciones,
        "creado_en": creadoEn,
        "imagenes": imagenes == null
            ? []
            : List<dynamic>.from(imagenes!.map((x) => x.toJson())),
      };
  bool get isPlanificado => estadoIncidencia != 'planificado';

  bool get isFinalizado => estadoIncidencia == 'finalizado';
}

class Imagene {
  final String? incidenciaVehiculosImagenesId;
  final String? notaImagen;
  final String? creadoEnImagen;
  final String? idImagen;
  final String? pathImagen;
  final String? descripcion;
  final String? creadoEn;

  Imagene({
    this.incidenciaVehiculosImagenesId,
    this.notaImagen,
    this.creadoEnImagen,
    this.idImagen,
    this.pathImagen,
    this.descripcion,
    this.creadoEn,
  });

  Imagene copyWith({
    String? incidenciaVehiculosImagenesId,
    String? notaImagen,
    String? creadoEnImagen,
  }) =>
      Imagene(
        incidenciaVehiculosImagenesId:
            incidenciaVehiculosImagenesId ?? this.incidenciaVehiculosImagenesId,
        notaImagen: notaImagen ?? this.notaImagen,
        creadoEnImagen: creadoEnImagen ?? this.creadoEnImagen,
        idImagen: idImagen ?? idImagen,
        pathImagen: pathImagen ?? pathImagen,
        descripcion: descripcion ?? descripcion,
        creadoEn: creadoEn ?? creadoEn,
      );

  factory Imagene.fromJson(Map<String, dynamic> json) => Imagene(
        incidenciaVehiculosImagenesId: json["incidencia_vehiculos_imagenes_id"],
        notaImagen: json["nota_imagen"],
        creadoEnImagen: json["creado_en_imagen"],
        idImagen: json["id_imagen"],
        pathImagen: json["path_imagen"],
        descripcion: json["descripcion"],
        creadoEn: json["creado_en"],
      );

  Map<String, dynamic> toJson() => {
        "incidencia_vehiculos_imagenes_id": incidenciaVehiculosImagenesId,
        "nota_imagen": notaImagen,
        "creado_en_imagen": creadoEnImagen,
        "id_imagen": idImagen,
        "path_imagen": pathImagen,
        "descripcion": descripcion,
        "creado_en": creadoEn,
      };
}
