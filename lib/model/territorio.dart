import 'dart:convert';

List<Territorio> territorioFromJson(String str) =>
    List<Territorio>.from(json.decode(str).map((x) => Territorio.fromJson(x)));

String territorioToJson(List<Territorio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Territorio {
  int? id;
  String? pais;
  String? provincia;
  String? municipio;
  String? sector;
  String? sectorCardinal;

  Territorio({
    this.id,
    this.pais,
    this.provincia,
    this.municipio,
    this.sector,
    this.sectorCardinal,
  });

  factory Territorio.fromJson(Map<String, dynamic> json) => Territorio(
        id: json['id'],
        pais: json['pais'],
        provincia: json['provincia'],
        municipio: json['municipio'],
        sector: json['sector'],
        sectorCardinal: json['sector_cardinal'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pais': pais,
        'provincia': provincia,
        'municipio': municipio,
        'sector': sector,
        'sector_cardinal': sectorCardinal,
      };

  @override
  String toString() {
    return '$sectorCardinal: $municipio, $sector';
  }

  // static List<String> getUniqueCardinal(List<Territorio> list) {
  //   return list.map((element) => element.sectorCardinal).toSet().toList();
  // }

  static List<String> getUniqueSector(List<Territorio> list) {
    return list
        .map((element) => element.sector!.toUpperCase())
        .toSet()
        .toList();
  }

  static List<String> getUniqueProvincia(List<Territorio> list) {
    return list
        .map((element) => element.provincia!.toUpperCase())
        .toSet()
        .toList();
  }
}
