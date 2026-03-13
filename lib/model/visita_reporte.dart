import 'dart:convert';

List<VisitaReporte> visitaReporteFromJson(String str) =>
    List<VisitaReporte>.from(
        json.decode(str).map((x) => VisitaReporte.fromJson(x)));

String visitaReporteToJson(List<VisitaReporte> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VisitaReporte {
  final int? idVehiculo;
  final int? idVisita;
  final String? lugar;
  final String? horaLlegada;
  final String? observacion;
  final int? idReporte;
  final String? marca;
  final String? ficha;

  VisitaReporte({
    this.idVehiculo,
    this.lugar,
    this.horaLlegada,
    this.observacion,
    this.idVisita,
    this.idReporte,
    this.marca,
    this.ficha,
  });

  factory VisitaReporte.fromJson(Map<String, dynamic> json) {
    return VisitaReporte(
      lugar: json['lugar'] ?? 'Sin lugar',
      horaLlegada: json['hora_llegada'] ?? '',
      observacion: json['observacion'] ?? 'N/A',
      idVisita: json["id_visita"],
      idReporte: json["id_reporte"],
      marca: json["marca"],
      ficha: json["ficha"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lugar": lugar,
        "id_vehiculo": idVehiculo,
        "hora_llegada": horaLlegada,
        "observacion": observacion,
        "id_visita": idVisita,
        "id_reporte": idReporte,
        "marca": marca,
        "ficha": ficha
      };

  static List<String> getUniqueFicha(List<VisitaReporte> list) {
    return list.map((element) => element.ficha!).toSet().toList();
  }
}
