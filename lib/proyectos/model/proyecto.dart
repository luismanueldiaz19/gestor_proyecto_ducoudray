// To parse this JSON data, do
//
//     final proyecto = proyectoFromJson(jsonString);
import 'dart:convert';

import '../../model/cliente.dart';

List<Proyecto> proyectoFromJson(String str) =>
    List<Proyecto>.from(json.decode(str).map((x) => Proyecto.fromJson(x)));

String proyectoToJson(List<Proyecto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proyecto {
  final String idProyecto;
  final String clienteId;
  final String nombre;
  final String alcance;
  final String entregables;
  final String cronograma;
  final String fechaInicio;
  final String fechaFin;
  final String costoProyecto;
  final String status;

  final Cliente cliente;
  final List<Gasto> gastos;
  final List<Equipo> equipo;
  final List<Cotizacione> cotizaciones;

  Proyecto({
    required this.idProyecto,
    required this.clienteId,
    required this.nombre,
    required this.alcance,
    required this.entregables,
    required this.cronograma,
    required this.fechaInicio,
    required this.fechaFin,
    required this.costoProyecto,
    required this.status,
    required this.gastos,
    required this.equipo,
    required this.cotizaciones,
    required this.cliente,
  });

  Proyecto copyWith({
    String? idProyecto,
    String? clienteId,
    String? nombre,
    String? alcance,
    String? entregables,
    String? cronograma,
    String? fechaInicio,
    String? fechaFin,
    String? costoProyecto,
    String? status,
    Cliente? cliente,
    List<Gasto>? gastos,
    List<Equipo>? equipo,
    List<Cotizacione>? cotizaciones,
  }) => Proyecto(
    idProyecto: idProyecto ?? this.idProyecto,
    clienteId: clienteId ?? this.clienteId,
    nombre: nombre ?? this.nombre,
    alcance: alcance ?? this.alcance,
    entregables: entregables ?? this.entregables,
    cronograma: cronograma ?? this.cronograma,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin ?? this.fechaFin,
    costoProyecto: costoProyecto ?? this.costoProyecto,
    status: status ?? this.status,
    gastos: gastos ?? this.gastos,
    equipo: equipo ?? this.equipo,
    cotizaciones: cotizaciones ?? this.cotizaciones,
    cliente: cliente ?? this.cliente,
  );

  factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
    idProyecto: json["id_proyecto"].toString(),
    clienteId: json["cliente_id"].toString(),
    nombre: json["nombre"].toString(),
    alcance: json["alcance"],
    entregables: json["entregables"].toString(),
    cronograma: json["cronograma"].toString(),
    fechaInicio: json["fecha_inicio"].toString(),
    fechaFin: json["fecha_fin"].toString(),
    costoProyecto: json["costo_proyecto"].toString(),
    status: json["status"].toString(),
    cliente: Cliente.fromJson(json["cliente"]),
    gastos: List<Gasto>.from(json["gastos"].map((x) => Gasto.fromJson(x))),
    equipo: List<Equipo>.from(json["equipo"].map((x) => Equipo.fromJson(x))),
    cotizaciones: List<Cotizacione>.from(
      json["cotizaciones"].map((x) => Cotizacione.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id_proyecto": idProyecto,
    "cliente_id": clienteId,
    "nombre": nombre,
    "alcance": alcance,
    "entregables": entregables,
    "cronograma": cronograma,
    "fecha_inicio": fechaInicio,
    "fecha_fin": fechaFin,
    "costo_proyecto": costoProyecto,
    "status": status,
    "cliente": cliente.toJson(),
    "gastos": List<dynamic>.from(gastos.map((x) => x.toJson())),
    "equipo": List<dynamic>.from(equipo.map((x) => x.toJson())),
    "cotizaciones": List<dynamic>.from(cotizaciones.map((x) => x.toJson())),
  };

  double get totalGastos {
    return gastos.fold(0.0, (sum, g) => sum + double.parse(g.monto));
  }

  double get totalCotizacion {
    return cotizaciones.fold(0.0, (sum, c) => sum + double.parse(c.monto));
  }

  double get balance {
    return totalCotizacion - totalGastos;
  }
}

class Cotizacione {
  final String idCotizacion;
  final String fecha;
  final String descripcion;
  final String monto;
  final String estado;

  Cotizacione({
    required this.idCotizacion,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    required this.estado,
  });

  Cotizacione copyWith({
    String? idCotizacion,
    String? fecha,
    String? descripcion,
    String? monto,
    String? estado,
  }) => Cotizacione(
    idCotizacion: idCotizacion ?? this.idCotizacion,
    fecha: fecha ?? this.fecha,
    descripcion: descripcion ?? this.descripcion,
    monto: monto ?? this.monto,
    estado: estado ?? this.estado,
  );

  factory Cotizacione.fromJson(Map<String, dynamic> json) => Cotizacione(
    idCotizacion: json["id_cotizacion"].toString(),
    fecha: json["fecha"].toString(),
    descripcion: json["descripcion"].toString(),
    monto: json["monto"].toString(),
    estado: json["estado"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id_cotizacion": idCotizacion,
    "fecha": fecha,
    "descripcion": descripcion,
    "monto": monto,
    "estado": estado,
  };
}

class Equipo {
  final String idEquipo;
  final String nombreMiembro;
  final String rol;
  final String horasAsignadas;

  Equipo({
    required this.idEquipo,
    required this.nombreMiembro,
    required this.rol,
    required this.horasAsignadas,
  });

  Equipo copyWith({
    String? idEquipo,
    String? nombreMiembro,
    String? rol,
    String? horasAsignadas,
  }) => Equipo(
    idEquipo: idEquipo ?? this.idEquipo,
    nombreMiembro: nombreMiembro ?? this.nombreMiembro,
    rol: rol ?? this.rol,
    horasAsignadas: horasAsignadas ?? this.horasAsignadas,
  );

  factory Equipo.fromJson(Map<String, dynamic> json) => Equipo(
    idEquipo: json["id_equipo"].toString(),
    nombreMiembro: json["nombre_miembro"].toString(),
    rol: json["rol"].toString(),
    horasAsignadas: json["horas_asignadas"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id_equipo": idEquipo,
    "nombre_miembro": nombreMiembro,
    "rol": rol,
    "horas_asignadas": horasAsignadas,
  };
}

class Gasto {
  final String idGasto;
  final String fecha;
  final String concepto;
  final String monto;
  final String tipo;

  Gasto({
    required this.idGasto,
    required this.fecha,
    required this.concepto,
    required this.monto,
    required this.tipo,
  });

  Gasto copyWith({
    String? idGasto,
    String? fecha,
    String? concepto,
    String? monto,
    String? tipo,
  }) => Gasto(
    idGasto: idGasto ?? this.idGasto,
    fecha: fecha ?? this.fecha,
    concepto: concepto ?? this.concepto,
    monto: monto ?? this.monto,
    tipo: tipo ?? this.tipo,
  );

  factory Gasto.fromJson(Map<String, dynamic> json) => Gasto(
    idGasto: json["id_gasto"].toString(),
    fecha: json["fecha"].toString(),
    concepto: json["concepto"].toString(),
    monto: json["monto"].toString(),
    tipo: json["tipo"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id_gasto": idGasto,
    "fecha": fecha,
    "concepto": concepto,
    "monto": monto,
    "tipo": tipo,
  };
}
