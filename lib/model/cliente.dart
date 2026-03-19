// To parse this JSON data, do
//
//     final cliente = clienteFromJson(jsonString);

import 'dart:convert';

List<Cliente> clienteFromJson(String str) =>
    List<Cliente>.from(json.decode(str).map((x) => Cliente.fromJson(x)));

String clienteToJson(List<Cliente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cliente {
  final String? clienteId;
  final String? nombre;

  final String? direccion;
  final String? telefono;
  final String? email;
  final String? tipoCliente;

  Cliente({
    this.clienteId,
    this.nombre,
    this.direccion,
    this.telefono,
    this.email,
    this.tipoCliente,
  });

  Cliente copyWith({
    String? clienteId,
    String? nombre,
    String? direccion,
    String? telefono,
    String? email,
    String? tipoCliente,
  }) => Cliente(
    clienteId: clienteId ?? this.clienteId,
    nombre: nombre ?? this.nombre,
    direccion: direccion ?? this.direccion,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    tipoCliente: tipoCliente ?? this.tipoCliente,
  );

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    clienteId: json["cliente_id"],
    nombre: json["nombre"],
    direccion: json["direccion"],
    telefono: json["telefono"],
    email: json["email"],
    tipoCliente: json["tipo_cliente"],
  );

  Map<String, dynamic> toJson() => {
    "cliente_id": clienteId,
    "nombre": nombre,
    "direccion": direccion,
    "telefono": telefono,
    "email": email,
    "tipo_cliente": tipoCliente,
  };

  static List<String> getUniqueCliente(List<Cliente> list) {
    return list.map((element) => element.nombre!).toSet().toList();
  }

  static List<String> getUniqueTipoCliente(List<Cliente> list) {
    return list.map((element) => element.tipoCliente!).toSet().toList();
  }
}
