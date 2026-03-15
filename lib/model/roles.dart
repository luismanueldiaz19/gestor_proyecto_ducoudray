// To parse this JSON data, do
//
//     final roles = rolesFromJson(jsonString);

import 'dart:convert';

List<Roles> rolesFromJson(String str) =>
    List<Roles>.from(json.decode(str).map((x) => Roles.fromJson(x)));

String rolesToJson(List<Roles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Roles {
  final String rolId;
  final String nombre;
  final String descripcion;
  final List<Permiso> permisos;

  Roles({
    required this.rolId,
    required this.nombre,
    required this.descripcion,
    required this.permisos,
  });

  Roles copyWith({
    String? rolId,
    String? nombre,
    String? descripcion,
    List<Permiso>? permisos,
  }) => Roles(
    rolId: rolId ?? this.rolId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    permisos: permisos ?? this.permisos,
  );

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
    rolId: json["rol_id"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    permisos: List<Permiso>.from(
      json["permisos"].map((x) => Permiso.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "rol_id": rolId,
    "nombre": nombre,
    "descripcion": descripcion,
    "permisos": List<dynamic>.from(permisos.map((x) => x.toJson())),
  };
}

class Permiso {
  final String permisoId;
  final String nombre;

  Permiso({required this.permisoId, required this.nombre});

  Permiso copyWith({String? permisoId, String? nombre}) => Permiso(
    permisoId: permisoId ?? this.permisoId,
    nombre: nombre ?? this.nombre,
  );

  factory Permiso.fromJson(Map<String, dynamic> json) =>
      Permiso(permisoId: json["permiso_id"], nombre: json["nombre"]);

  Map<String, dynamic> toJson() => {"permiso_id": permisoId, "nombre": nombre};

  static List<String> getUniquePermisos(List<Permiso> list) {
    return list.map((element) => element.nombre).toSet().toList();
  }
}
