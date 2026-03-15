import 'package:ducoudray/proyectos/model/proyecto.dart';
import 'package:flutter/material.dart';

class ScreenDetailsProyecto extends StatelessWidget {
  final Proyecto proyecto;

  const ScreenDetailsProyecto({super.key, required this.proyecto});

  @override
  Widget build(BuildContext context) {
    double totalGastos = proyecto.gastos.fold(
      0,
      (sum, item) => sum + double.parse(item.monto),
    );

    double cotizado = proyecto.cotizaciones.fold(
      0,
      (sum, item) => sum + double.parse(item.monto),
    );

    double balance = cotizado - totalGastos;

    return Scaffold(
      appBar: AppBar(title: Text(proyecto.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROYECTO
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Información del Proyecto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    infoRow("Nombre", proyecto.nombre),
                    infoRow("Alcance", proyecto.alcance),
                    infoRow("Entregables", proyecto.entregables),
                    infoRow("Cronograma", proyecto.cronograma),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// CLIENTE
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cliente",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    infoRow("Nombre", proyecto.cliente.nombre ?? '---'),
                    infoRow("Teléfono", proyecto.cliente.telefono ?? '---'),
                    infoRow("Dirección", proyecto.cliente.direccion ?? '---'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// FECHAS
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    infoRow("Fecha Inicio", proyecto.fechaInicio),
                    infoRow("Fecha Fin", proyecto.fechaFin),
                    infoRow("Status", proyecto.status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// EQUIPO
            const Text(
              "Equipo del Proyecto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...proyecto.equipo.map((e) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(e.nombreMiembro),
                  subtitle: Text("Rol: ${e.rol}"),
                  trailing: Text("${e.horasAsignadas} h"),
                ),
              );
            }),

            const SizedBox(height: 20),

            /// GASTOS
            const Text(
              "Gastos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...proyecto.gastos.map((g) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.money_off),
                  title: Text(g.concepto),
                  subtitle: Text(g.fecha),
                  trailing: Text("\$${g.monto}"),
                ),
              );
            }),

            const SizedBox(height: 20),

            /// COTIZACIONES
            const Text(
              "Cotizaciones",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...proyecto.cotizaciones.map((c) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.request_quote),
                  title: Text(c.descripcion),
                  subtitle: Text(c.fecha),
                  trailing: Text("\$${c.monto}"),
                ),
              );
            }),

            const SizedBox(height: 20),

            /// RESUMEN FINANCIERO
            Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    infoRow(
                      "Total Gastos",
                      "\$${totalGastos.toStringAsFixed(2)}",
                    ),
                    infoRow(
                      "Total Cotizado",
                      "\$${cotizado.toStringAsFixed(2)}",
                    ),
                    infoRow("Balance", "\$${balance.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
