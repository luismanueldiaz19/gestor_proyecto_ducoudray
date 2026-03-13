// To parse this JSON data, do
//
//     final licenciaChofer = licenciaChoferFromJson(jsonString);

import 'dart:convert';

LicenciaChofer licenciaChoferFromJson(String str) =>
    LicenciaChofer.fromJson(json.decode(str));

String licenciaChoferToJson(LicenciaChofer data) => json.encode(data.toJson());

class LicenciaChofer {
  final String? licenciaChoferId;
  final String? usuarioId;
  final String? nombreChofer;
  final String? categoria;
  final String? restrinciones;
  final String? fechaEmision;
  final String? firstEmision;
  final String? estatura;
  final String? peso;
  final String? sexo;
  final String? tipoSangre;
  final String? nacimiento;
  final String? vence;
  final String? idCedula;
  final String? estadoVencimiento;

  LicenciaChofer(
      {this.licenciaChoferId,
      this.usuarioId,
      this.nombreChofer,
      this.categoria,
      this.restrinciones,
      this.fechaEmision,
      this.firstEmision,
      this.estatura,
      this.peso,
      this.sexo,
      this.tipoSangre,
      this.nacimiento,
      this.vence,
      this.idCedula,
      this.estadoVencimiento});

  LicenciaChofer copyWith({
    String? licenciaChoferId,
    String? usuarioId,
    String? nombreChofer,
    String? categoria,
    String? restrinciones,
    String? fechaEmision,
    String? firstEmision,
    String? estatura,
    String? peso,
    String? sexo,
    String? tipoSangre,
    String? nacimiento,
    String? vence,
    String? idCedula,
    String? estadoVencimiento,
  }) =>
      LicenciaChofer(
        licenciaChoferId: licenciaChoferId ?? this.licenciaChoferId,
        usuarioId: usuarioId ?? this.usuarioId,
        nombreChofer: nombreChofer ?? this.nombreChofer,
        categoria: categoria ?? this.categoria,
        restrinciones: restrinciones ?? this.restrinciones,
        fechaEmision: fechaEmision ?? this.fechaEmision,
        firstEmision: firstEmision ?? this.firstEmision,
        estatura: estatura ?? this.estatura,
        peso: peso ?? this.peso,
        sexo: sexo ?? this.sexo,
        tipoSangre: tipoSangre ?? this.tipoSangre,
        nacimiento: nacimiento ?? this.nacimiento,
        vence: vence ?? this.vence,
        idCedula: idCedula ?? this.idCedula,
        estadoVencimiento: estadoVencimiento ?? this.estadoVencimiento,
      );

  factory LicenciaChofer.fromJson(Map<String, dynamic> json) => LicenciaChofer(
        licenciaChoferId: json["licencia_chofer_id"],
        usuarioId: json["usuario_id"],
        nombreChofer: json["nombre_chofer"],
        categoria: json["categoria"],
        restrinciones: json["restrinciones"],
        fechaEmision: json["fecha_emision"],
        firstEmision: json["first_emision"],
        estatura: json["estatura"],
        peso: json["peso"],
        sexo: json["sexo"],
        tipoSangre: json["tipo_sangre"],
        nacimiento: json["nacimiento"],
        vence: json["vence"],
        idCedula: json["id_cedula"],
        estadoVencimiento: json["estado_vencimiento"],
      );

  Map<String, dynamic> toJson() => {
        "licencia_chofer_id": licenciaChoferId,
        "usuario_id": usuarioId,
        "nombre_chofer": nombreChofer,
        "categoria": categoria,
        "restrinciones": restrinciones,
        "fecha_emision": fechaEmision,
        "first_emision": firstEmision,
        "estatura": estatura,
        "peso": peso,
        "sexo": sexo,
        "tipo_sangre": tipoSangre,
        "nacimiento": nacimiento,
        "vence": vence,
        "id_cedula": idCedula,
        "estado_vencimiento": estadoVencimiento,
      };
}
