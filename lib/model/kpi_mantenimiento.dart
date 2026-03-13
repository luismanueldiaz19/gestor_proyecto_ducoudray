class TipoServicioKPI {
  final String tipoServicio;
  final String categoria;
  final String mes;
  final int totalServicios;

  TipoServicioKPI(
      {required this.tipoServicio,
      required this.categoria,
      required this.mes,
      required this.totalServicios});

  factory TipoServicioKPI.fromJson(Map<String, dynamic> json) {
    return TipoServicioKPI(
      tipoServicio: json['tipo_servicio'],
      categoria: json['categoria'],
      mes: json['mes'],
      totalServicios: int.parse(json['total_servicios'].toString()),
    );
  }
}

class CategoriaKPI {
  final String categoriaServicio;
  final String mes;
  final int totalServicios;

  CategoriaKPI(
      {required this.categoriaServicio,
      required this.mes,
      required this.totalServicios});

  factory CategoriaKPI.fromJson(Map<String, dynamic> json) {
    return CategoriaKPI(
      categoriaServicio: json['categoria_servicio'],
      mes: json['mes'],
      totalServicios: int.parse(json['total_servicios'].toString()),
    );
  }
}

class VehiculoKPI {
  final String ficha;
  final String marca;
  final String mes;
  final int totalServicios;

  VehiculoKPI(
      {required this.ficha,
      required this.marca,
      required this.mes,
      required this.totalServicios});

  factory VehiculoKPI.fromJson(Map<String, dynamic> json) {
    return VehiculoKPI(
      ficha: json['ficha'],
      marca: json['marca'],
      mes: json['mes'],
      totalServicios: int.parse(json['total_servicios'].toString()),
    );
  }
}
