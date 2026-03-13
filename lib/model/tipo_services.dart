import 'dart:convert';

List<TipoServices> tiposervicesFromJson(String str) => List<TipoServices>.from(
    json.decode(str).map((x) => TipoServices.fromJson(x)));

// String territorioToJson(List<Territorio> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoServices {
  TipoServices({
    this.idTipo,
    this.nombre,
    this.categoria,
    this.descripcion,
  });

  final String? idTipo;
  final String? nombre;
  final String? categoria;
  final String? descripcion;

  factory TipoServices.fromJson(Map<String, dynamic> json) {
    return TipoServices(
      idTipo: json["id_tipo"],
      nombre: json["nombre"],
      categoria: json["categoria"],
      descripcion: json["descripcion"],
    );
  }

  TipoServices copyWith(
      {String? nombre,
      String? idTipo,
      String? categoria,
      String? descripcion}) {
    return TipoServices(
      nombre: nombre ?? nombre,
      categoria: categoria ?? categoria,
      descripcion: descripcion ?? descripcion,
      idTipo: idTipo ?? idTipo,
    );
  }

  toJson() {
    return {
      "id_tipo": idTipo,
      "nombre": nombre,
      "categoria": categoria,
      "descripcion": descripcion,
    };
  }

  @override
  String toString() {
    return nombre ?? 'N/A';
  }

  static List<String> getUniqueCategoria(List<TipoServices> list) {
    return list.map((element) => element.nombre!).toSet().toList();
  }
}
