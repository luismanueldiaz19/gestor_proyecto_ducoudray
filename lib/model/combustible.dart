import 'dart:convert';

List<TipoCombustible> combustibleFromJson(String str) =>
    List<TipoCombustible>.from(
        json.decode(str).map((x) => TipoCombustible.fromJson(x)));

String combustibleToJson(List<TipoCombustible> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoCombustible {
  final int? tipoCombustibleId;
  final String? nombre;
  final String? descripcion;

  TipoCombustible({
    this.tipoCombustibleId,
    this.nombre,
    this.descripcion,
  });

  // Factory constructor para crear una instancia desde un mapa JSON
  factory TipoCombustible.fromJson(Map<String, dynamic> json) {
    return TipoCombustible(
      tipoCombustibleId: int.parse(json['tipo_combustible_id'].toString()),
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  // Método para convertir la instancia a un mapa JSON (opcional)
  Map<String, dynamic> toJson() {
    return {
      'tipo_combustible_id': tipoCombustibleId,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  @override
  String toString() {
    return 'TipoCombustible(id: $tipoCombustibleId, nombre: $nombre, descripcion: $descripcion)';
  }
}
