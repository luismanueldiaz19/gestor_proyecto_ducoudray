import 'dart:convert';

import 'package:ducoudray/model/licencia_chofer.dart';

List<Usuario> usuarioFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  final String? usuarioId;
  final String? usuario;
  final String? nombreCompleto;
  final String? status;
  final List<String>? roles;
  final List<String>? permisos;

  final LicenciaChofer? licenciaChofer;

  Usuario({
    this.usuarioId,
    this.usuario,
    this.nombreCompleto,
    this.status,
    this.roles,
    this.permisos,

    this.licenciaChofer,
  });

  Usuario copyWith({
    String? usuarioId,
    String? usuario,
    String? nombreCompleto,
    String? status,
    List<String>? roles,
    List<String>? permisos,

    LicenciaChofer? licenciaChofer,
  }) => Usuario(
    usuarioId: usuarioId ?? this.usuarioId,
    usuario: usuario ?? this.usuario,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    status: status ?? this.status,
    roles: roles ?? this.roles,
    permisos: permisos ?? this.permisos,

    licenciaChofer: licenciaChofer ?? this.licenciaChofer,
  );

  bool get statusUsuario => status == 't' || status == 'true';

  factory Usuario.fromRawJson(String str) => Usuario.fromJson(json.decode(str));

  @override
  String toString() => '$nombreCompleto';

  String toRawJson() => json.encode(toJson());

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    usuarioId: json["usuario_id"].toString(),
    usuario: json["usuario"],
    nombreCompleto: json["nombre_completo"],
    status: json["status"],
    roles: json["roles"] == null
        ? []
        : List<String>.from(json["roles"]!.map((x) => x)),
    permisos: json["permisos"] == null
        ? []
        : List<String>.from(json["permisos"]!.map((x) => x)),

    licenciaChofer: json["licencia_chofer"] == null
        ? null
        : LicenciaChofer.fromJson(json["licencia_chofer"]),
  );

  Map<String, dynamic> toJson() => {
    "usuario_id": usuarioId,
    "usuario": usuario,
    "nombre_completo": nombreCompleto,
    "status": status,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "permisos": permisos == null
        ? []
        : List<dynamic>.from(permisos!.map((x) => x)),

    "licencia_chofer": licenciaChofer?.toJson(),
  };
  bool tieneRol(String rol) {
    return roles?.contains(rol.toLowerCase()) ?? false;
  }

  bool tienePermiso(String permiso) {
    // return permisos?.contains(rol.toLowerCase()) ?? false;
    if (permisos == null) return false;

    final p = permiso.toLowerCase();

    return permisos!.contains('administrador') || permisos!.contains(p);
  }

  static List<String> getUniqueNombreCompleto(List<Usuario> list) {
    return list
        .map((element) => element.nombreCompleto!.toUpperCase())
        .toSet()
        .toList();
  }
}
