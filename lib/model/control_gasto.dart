import 'dart:convert';

List<ControlGasto> controlGastoFromJson(String str) => List<ControlGasto>.from(
    json.decode(str).map((x) => ControlGasto.fromJson(x)));

String controlGastoToJson(List<ControlGasto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ControlGasto {
  final String idRecursoHumanoGastoFicha;
  final String recurso;
  final String monto;
  final String fecha;
  final String creadoPor;
  final String creadoEn;

  ControlGasto({
    required this.idRecursoHumanoGastoFicha,
    required this.recurso,
    required this.monto,
    required this.fecha,
    required this.creadoPor,
    required this.creadoEn,
  });

  ControlGasto copyWith({
    String? idRecursoHumanoGastoFicha,
    String? recurso,
    String? monto,
    String? fecha,
    String? creadoPor,
    String? creadoEn,
  }) =>
      ControlGasto(
        idRecursoHumanoGastoFicha:
            idRecursoHumanoGastoFicha ?? this.idRecursoHumanoGastoFicha,
        recurso: recurso ?? this.recurso,
        monto: monto ?? this.monto,
        fecha: fecha ?? this.fecha,
        creadoPor: creadoPor ?? this.creadoPor,
        creadoEn: creadoEn ?? this.creadoEn,
      );

  factory ControlGasto.fromJson(Map<String, dynamic> json) => ControlGasto(
        idRecursoHumanoGastoFicha: json["id_recurso_humano_gasto_ficha"],
        recurso: json["recurso"],
        monto: json["monto"],
        fecha: json["fecha"],
        creadoPor: json["creado_por"],
        creadoEn: json["creado_en"],
      );

  Map<String, dynamic> toJson() => {
        "id_recurso_humano_gasto_ficha": idRecursoHumanoGastoFicha,
        "recurso": recurso,
        "monto": monto,
        "fecha": fecha,
        "creado_por": creadoPor,
        "creado_en": creadoEn,
      };
}
