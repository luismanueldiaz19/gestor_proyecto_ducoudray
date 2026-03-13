class ItemCombustible {
  int? itemCombustibleId;
  String? nombreDivicion;
  int? compraCombustibleId;
  int? divicionStockId;
  int? tipoCombustibleId;
  double? cantidad;
  double? precioPorCantidad;

  String? tipoCombustible;
  String? descripcionCombustible;

  ItemCombustible({
    this.itemCombustibleId,
    this.nombreDivicion,
    this.compraCombustibleId,
    this.divicionStockId,
    this.tipoCombustibleId,
    this.cantidad,
    this.precioPorCantidad,
    this.descripcionCombustible,
    this.tipoCombustible,
  });

  factory ItemCombustible.fromJson(Map<String, dynamic> json) {
    return ItemCombustible(
      itemCombustibleId:
          int.tryParse(json['item_combustible_id']?.toString() ?? '0') ?? 0,
      compraCombustibleId:
          int.tryParse(json['compra_combustible_id']?.toString() ?? '0') ?? 0,
      divicionStockId:
          int.tryParse(json['divicion_stock_id']?.toString() ?? '0') ?? 0,
      tipoCombustibleId:
          int.tryParse(json['tipo_combustible_id']?.toString() ?? '0') ?? 0,
      cantidad: double.tryParse(json['cantidad']?.toString() ?? '0') ?? 0,
      precioPorCantidad:
          double.tryParse(json['precio_por_cantidad']?.toString() ?? '0') ?? 0,
      descripcionCombustible: json['descripcion_combustible'],
      nombreDivicion: json['nombre_divicion'],
      tipoCombustible: json['tipo_combustible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_combustible_id': itemCombustibleId,
      'compra_combustible_id': compraCombustibleId,
      'divicion_stock_id': divicionStockId,
      'tipo_combustible_id': tipoCombustibleId,
      'cantidad': cantidad,
      'precio_por_cantidad': precioPorCantidad,
      'nombre_divicion': nombreDivicion,
      'tipo_combustible': tipoCombustible,
      'descripcion_combustible': descripcionCombustible,
    };
  }

  static double calcularSubtotal(double? cantidad, double? precio) {
    if (cantidad == null || precio == null || cantidad < 0 || precio < 0) {
      return 0.0;
    }
    return cantidad * precio;
  }

  static String getTotal(List<ItemCombustible> collection) {
    double totalOrden = 0.0;

    for (var element in collection) {
      totalOrden += calcularSubtotal(element.cantidad,element.precioPorCantidad);
    }
    return totalOrden.toStringAsFixed(0);
  }
}
