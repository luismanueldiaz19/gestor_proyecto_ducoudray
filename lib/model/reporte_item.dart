class ReporteItem {
  final String? mes;
  final int? numMes;
  final String? division;
  final String? tipoCombustible;
  final double? totalCantidad;
  final double? subtotal; // Solo para data1
  final double? totalGeneral; // Para data2 y data3

  ReporteItem({
    this.mes,
    this.numMes,
    this.division,
    this.tipoCombustible,
    this.totalCantidad,
    this.subtotal,
    this.totalGeneral,
  });

  factory ReporteItem.fromJson(Map<String, dynamic> json) {
    return ReporteItem(
      mes: json['mes'],
      numMes: int.tryParse(json['num_mes'].toString()),
      division: json['division'],
      tipoCombustible: json['tipo_combustible'],
      totalCantidad: double.tryParse(json['total_cantidad'].toString()),
      subtotal: json.containsKey('subtotal')
          ? double.tryParse(json['subtotal'].toString())
          : null,
      totalGeneral: json.containsKey('total_general')
          ? double.tryParse(json['total_general'].toString())
          : null,
    );
  }
}
