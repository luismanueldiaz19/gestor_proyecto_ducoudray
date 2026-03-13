// To parse this JSON data, do
//
//     final productos = productosFromJson(jsonString);

import 'dart:convert';

List<Productos> productosFromJson(String str) =>
    List<Productos>.from(json.decode(str).map((x) => Productos.fromJson(x)));

String productosToJson(List<Productos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Productos {
  final String idProducto;
  final String nombre;
  final String descripcion;
  final String precio;
  final String stock;

  Productos({
    required this.idProducto,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });

  factory Productos.fromJson(Map<String, dynamic> json) => Productos(
      idProducto: json["id_producto"] ?? '0',
      nombre: json["nombre"] ?? 'N/A',
      descripcion: json["descripcion"] ?? 'N/A',
      precio: json["precio"].toString(),
      stock: json["stock"] ?? 'N/A');

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "stock": stock,
      };
}
