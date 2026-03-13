import 'dart:convert';

List<DivicionStock> divicionFromJson(String str) => List<DivicionStock>.from(
    json.decode(str).map((x) => DivicionStock.fromJson(x)));

String divicionToJson(List<DivicionStock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DivicionStock {
  final int divicionStockId;
  final String divicion;

  DivicionStock({
    required this.divicionStockId,
    required this.divicion,
  });

  // Constructor desde JSON
  factory DivicionStock.fromJson(Map<String, dynamic> json) {
    return DivicionStock(
      divicionStockId: json['divicion_stock_id'],
      divicion: json['divicion'],
    );
  }

  // Convertir a JSON (por ejemplo, para enviar a una API)
  Map<String, dynamic> toJson() {
    return {
      'divicion_stock_id': divicionStockId,
      'divicion': divicion,
    };
  }

  @override
  String toString() {
    return 'DivicionStock(id: $divicionStockId, divicion: $divicion)';
  }
}
