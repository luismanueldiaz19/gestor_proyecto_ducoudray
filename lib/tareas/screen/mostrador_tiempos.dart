import 'package:flutter/material.dart';
import '../../widgets/custom_loading.dart';
import '../model/tarea_historia.dart';
import '../model/tiempo_tareas.dart';
import '../repositories/tarea_repositories.dart';

class MostradorTiempos extends StatefulWidget {
  const MostradorTiempos({super.key, this.item});
  final TareaHistoria? item;

  @override
  State createState() => _MostradorTiemposState();
}

class _MostradorTiemposState extends State<MostradorTiempos> {
  List<TiempoTarea> _listFilter = [];
  Future<void> fetchTareas() async {
    try {
      _listFilter = await TareaRepositories.getTiempoTareas(
        widget.item!.tareaId!,
      );
    } catch (e) {
      debugPrint('Error al obtener reportes: $e');
      _listFilter = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchTareas();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          6,
        ), // 👈 esquinas suaves estilo Windows
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.25,
        vertical: size.height * 0.25,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade200, // 👈 barra superior estilo Windows
              child: Row(
                children: const [
                  Icon(Icons.title, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    "Tiempos de la tareas realizadas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            _listFilter.isEmpty
                ? Expanded(
                    child: CustomLoading(scale: 10, text: 'No hay registros'),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              Colors.grey.shade200,
                            ), // estilo Windows
                            // dataRowHeight: 38,
                            headingRowHeight: 42,
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                            ),

                            columnSpacing: 22,
                            horizontalMargin: 12,
                            columns: const [
                              DataColumn(label: Text('TIEMPO ID')),
                              DataColumn(label: Text('TAREA ID')),
                              DataColumn(label: Text('INICIO')),
                              DataColumn(label: Text('FIN')),
                              DataColumn(label: Text('HORAS')),
                            ],
                            rows: _listFilter.asMap().entries.map((entry) {
                              int index = entry.key;
                              var report = entry.value;
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color>((
                                  Set<WidgetState> states,
                                ) {
                                  // Alterna el color de fondo entre gris y blanco
                                  if (index.isOdd) {
                                    return Colors
                                        .grey
                                        .shade300; // Color de fondo gris para filas impares
                                  }
                                  return Colors
                                      .white; // Color de fondo blanco para filas pares
                                }),
                                cells: [
                                  DataCell(Text(report.tiempoId ?? 'N/A')),
                                  DataCell(Text(report.tareaId ?? 'N/A')),
                                  DataCell(Text(report.inicio ?? 'N/A')),
                                  DataCell(Text(report.fin ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      report.horas
                                              ?.toStringAsFixed(2)
                                              .toString() ??
                                          'Error',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
