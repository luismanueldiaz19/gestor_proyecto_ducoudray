// To parse this JSON data, do
//
//     final ajustesInventario = ajustesInventarioFromJson(jsonString);

import 'dart:convert';

List<AjustesInventario> ajustesInventarioFromJson(String str) =>
    List<AjustesInventario>.from(
        json.decode(str).map((x) => AjustesInventario.fromJson(x)));

String ajustesInventarioToJson(List<AjustesInventario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AjustesInventario {
  final String? stockCombustibleAjusteId;
  final String? divicion;
  final String? combustible;
  final String? balanceAnterior;
  final String? ajuste;
  final String? galones;
  final String? precio;
  final String? registed;
  final String? created;

  AjustesInventario({
    this.stockCombustibleAjusteId,
    this.divicion,
    this.combustible,
    this.balanceAnterior,
    this.ajuste,
    this.galones,
    this.precio,
    this.registed,
    this.created,
  });

  AjustesInventario copyWith({
    String? stockCombustibleAjusteId,
    String? divicion,
    String? combustible,
    String? balanceAnterior,
    String? ajuste,
    String? galones,
    String? precio,
    String? registed,
    String? created,
  }) =>
      AjustesInventario(
        stockCombustibleAjusteId:
            stockCombustibleAjusteId ?? this.stockCombustibleAjusteId,
        divicion: divicion ?? this.divicion,
        combustible: combustible ?? this.combustible,
        balanceAnterior: balanceAnterior ?? this.balanceAnterior,
        ajuste: ajuste ?? this.ajuste,
        galones: galones ?? this.galones,
        precio: precio ?? this.precio,
        registed: registed ?? this.registed,
        created: created ?? this.created,
      );

  factory AjustesInventario.fromJson(Map<String, dynamic> json) =>
      AjustesInventario(
        stockCombustibleAjusteId: json["stock_combustible_ajuste_id"],
        divicion: json["divicion"],
        combustible: json["combustible"],
        balanceAnterior: json["balance_anterior"],
        ajuste: json["ajuste"],
        galones: json["galones"],
        precio: json["precio"],
        registed: json["registed"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "stock_combustible_ajuste_id": stockCombustibleAjusteId,
        "divicion": divicion,
        "combustible": combustible,
        "balance_anterior": balanceAnterior,
        "ajuste": ajuste,
        "galones": galones,
        "precio": precio,
        "registed": registed,
        "created": created,
      };

      
      
       static List<String> getUniqueCombustible(List<AjustesInventario> list) {
          return list.map((element) => element.combustible!).toSet().toList();
        }

  static List<String> getUniqueDivicion(List<AjustesInventario> list) {
    return list.map((element) => element.divicion!).toSet().toList();
  }
      
}
