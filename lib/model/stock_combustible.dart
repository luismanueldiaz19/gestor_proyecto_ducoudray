import 'dart:convert';

List<StockCombustible> stockCombustibleFromJson(String str) =>
    List<StockCombustible>.from(
        json.decode(str).map((x) => StockCombustible.fromJson(x)));

String stockCombustibleToJson(List<StockCombustible> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockCombustible {
  final int stockCombustibleId;
  final int divicionStockId;
  final String nombreDivision;
  final int tipoCombustibleId;
  final String nombreCombustible;
  final String descripcion;
  final double galones;
  final double precioPorGalon;

  StockCombustible({
    required this.stockCombustibleId,
    required this.divicionStockId,
    required this.nombreDivision,
    required this.tipoCombustibleId,
    required this.nombreCombustible,
    required this.descripcion,
    required this.galones,
    required this.precioPorGalon,
  });

  factory StockCombustible.fromJson(Map<String, dynamic> json) {
    return StockCombustible(
      stockCombustibleId: int.parse(json['stock_combustible_id'].toString()),
      divicionStockId: int.parse(json['divicion_stock_id'].toString()),
      nombreDivision: json['nombre_division'],
      tipoCombustibleId: int.parse(json['tipo_combustible_id'].toString()),
      nombreCombustible: json['nombre_combustible'],
      descripcion: json['descripcion'],
      galones: double.parse(json['galones'].toString()),
      precioPorGalon: double.parse(json['precio_por_galon'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'stock_combustible_id': stockCombustibleId,
        'divicion_stock_id': divicionStockId,
        'nombre_division': nombreDivision,
        'tipo_combustible_id': tipoCombustibleId,
        'nombre_combustible': nombreCombustible,
        'descripcion': descripcion,
        'galones': galones,
        'precio_por_galon': precioPorGalon,
      };
  static List<String> depurarDivicion(List<StockCombustible> list) {
    return list.map((element) => element.nombreDivision).toSet().toList();
  }

  static double calcularSubtotal(double? cantidad, double? precio) {
    if (cantidad == null || precio == null || cantidad < 0 || precio < 0) {
      return 0.0;
    }
    return cantidad * precio;
  }
}
