class ReportMantenimiento {
  String idVehiculo;
  int idTipo;
  String descripcion;
  String? estado;
  String? prioridad;
  String? usuarioReporto;
  String? fechaReporte;
  String? observaciones;
  String? resueltoPor;
  double? costo;
  String? taller;
  List<ImagenReporte>? imagenes;

  ReportMantenimiento({
    required this.idVehiculo,
    required this.idTipo,
    required this.descripcion,
    this.estado,
    this.prioridad,
    this.usuarioReporto,
    this.fechaReporte,
    this.observaciones,
    this.resueltoPor,
    this.costo,
    this.taller,
    this.imagenes,
  });

  Map<String, dynamic> toJson() => {
        'id_vehiculo': idVehiculo,
        'id_tipo': idTipo,
        'descripcion': descripcion,
        'estado': estado ?? 'Abierto',
        'prioridad': prioridad ?? 'Media',
        'usuario_reporto': usuarioReporto ?? 'N/A',
        'fecha_reporte': fechaReporte ?? DateTime.now().toIso8601String(),
        'observaciones': observaciones ?? 'N/A',
        'resuelto_por': resueltoPor ?? '',
        'costo': costo ?? 0,
        'taller': taller ?? '',
        'imagenes': imagenes?.map((img) => img.toJson()).toList(),
      };
}

class ImagenReporte {
  String comentario;
  String path;
  String nameFile;

  ImagenReporte({
    required this.comentario,
    required this.path,
    required this.nameFile,
  });

  factory ImagenReporte.fromJson(Map<String, dynamic> json) {
    return ImagenReporte(
        comentario: json['comentario'] ?? 'Sin Comentario',
        path: json['path'],
        nameFile: json['name_file']);
  }

  Map<String, dynamic> toJson() => {
        'comentario': comentario,
        'path': path,
        'name_file': nameFile,
      };
}
