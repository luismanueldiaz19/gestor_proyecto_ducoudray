import 'dart:convert';

List<Seguro> seguroFromJson(String str) =>
    List<Seguro>.from(json.decode(str).map((x) => Seguro.fromJson(x)));

String seguroToJson(List<Seguro> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Seguro {
  final String? segurosVehiculoId;
  final String? aseguradora;
  final String? estadoSeguro;
  final String? numeroPoliza;
  final String? tipoSeguro;
  final String? fechaInicio;
  final String? fechaFin;
  final String? fechaRegistro;
  final String? pathImagen;
  final String? placas;
  final String? marca;
  final String? color;
  final String? ficha;

  Seguro({
    this.segurosVehiculoId,
    this.aseguradora,
    this.estadoSeguro,
    this.numeroPoliza,
    this.tipoSeguro,
    this.fechaInicio,
    this.fechaFin,
    this.fechaRegistro,
    this.pathImagen,
    this.marca,
    this.color,
    this.placas,
    this.ficha,
  });

  Seguro copyWith({
    String? segurosVehiculoId,
    String? aseguradora,
    String? estadoSeguro,
    String? numeroPoliza,
    String? tipoSeguro,
    String? fechaInicio,
    String? fechaFin,
    String? fechaRegistro,
    String? pathImagen,
  }) =>
      Seguro(
        segurosVehiculoId: segurosVehiculoId ?? this.segurosVehiculoId,
        aseguradora: aseguradora ?? this.aseguradora,
        estadoSeguro: estadoSeguro ?? this.estadoSeguro,
        numeroPoliza: numeroPoliza ?? this.numeroPoliza,
        tipoSeguro: tipoSeguro ?? this.tipoSeguro,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
        fechaRegistro: fechaRegistro ?? this.fechaRegistro,
        pathImagen: pathImagen ?? this.pathImagen,
      );

  factory Seguro.fromJson(Map<String, dynamic> json) => Seguro(
        segurosVehiculoId: json["seguros_vehiculo_id"],
        aseguradora: json["aseguradora"],
        estadoSeguro: json["estado_seguro"],
        numeroPoliza: json["numero_poliza"],
        tipoSeguro: json["tipo_seguro"],
        fechaInicio: json["fecha_inicio"],
        fechaFin: json["fecha_fin"],
        fechaRegistro: json["fecha_registro"],
        pathImagen: json["path_imagen"],
        color: json['color'],
        marca: json['marca'],
        placas: json['placas'],
        ficha: json['ficha'],
      );

  Map<String, dynamic> toJson() => {
        "seguros_vehiculo_id": segurosVehiculoId,
        "aseguradora": aseguradora,
        "estado_seguro": estadoSeguro,
        "numero_poliza": numeroPoliza,
        "tipo_seguro": tipoSeguro,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "fecha_registro": fechaRegistro,
        "path_imagen": pathImagen,
        "color": color,
        "marca": marca,
        "placas": placas,
        "ficha": ficha,
      };
  @override
  String toString() {
    return "$ficha-$marca-$placas";
  }
}
