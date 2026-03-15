import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/proyectos/provider/provider_proyecto.dart';
import 'package:ducoudray/proyectos/screens/screen_details_proyecto.dart';
import 'package:ducoudray/utils/get_number_formate.dart';
import 'package:ducoudray/utils/helpers.dart';
import 'package:ducoudray/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenProyecto extends StatefulWidget {
  const ScreenProyecto({super.key});

  @override
  State createState() => _ScreenProyectoState();
}

class _ScreenProyectoState extends State<ScreenProyecto> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Mis Proyectos',
            style: style.titleLarge?.copyWith(color: AppColors.tealGreen),
          ),
        ),

        Consumer<ProviderProyecto>(
          builder: (context, provider, child) {
            final proyectos = provider.proyecto;
            if (proyectos.isEmpty) {
              return Expanded(
                child: Center(
                  child: CustomLoading(
                    text: 'No hay proyectos',
                    imagen: 'assets/study.png',
                  ),
                ),
              );
            }

            return Expanded(
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
                      border: TableBorder.all(color: Colors.grey.shade300),

                      columnSpacing: 22,
                      horizontalMargin: 12,
                      columns: const [
                        DataColumn(label: Text("CLIENTE")),
                        DataColumn(label: Text("PROYECTO")),
                        DataColumn(label: Text("FECHAS")),
                        DataColumn(label: Text("EQUIPO")),
                        DataColumn(label: Text("GASTOS")),
                        DataColumn(label: Text("COTIZADO")),
                        DataColumn(label: Text("BALANCE")),
                        DataColumn(label: Text("STATUS")),
                        DataColumn(label: Text("ACCIONES")),
                      ],
                      rows: proyectos.asMap().entries.map((entry) {
                        int index = entry.key;
                        var proyecto = entry.value;

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
                            /// CLIENTE
                            DataCell(
                              Text(
                                limitarTexto(
                                  proyecto.cliente.nombre ?? 'N/A',
                                  25,
                                ),
                              ),
                            ),

                            /// PROYECTO
                            DataCell(
                              limitaTextTool(
                                context,
                                proyecto.nombre,
                                25,
                                title: 'PROYECTO',
                              ),
                            ),

                            /// FECHAS
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.play_circle_fill,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        proyecto.fechaInicio ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        proyecto.fechaFin ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            /// EQUIPO
                            DataCell(Text(proyecto.equipo.length.toString())),

                            /// GASTOS
                            DataCell(
                              Text(
                                "\$ ${getNumFormatedDouble(proyecto.totalGastos.toStringAsFixed(2))}",
                              ),
                            ),

                            /// COTIZADO
                            DataCell(
                              Text(
                                "\$${getNumFormatedDouble(proyecto.totalCotizacion.toStringAsFixed(2))}",
                              ),
                            ),

                            /// BALANCE
                            DataCell(
                              Text(
                                "\$ ${getNumFormatedDouble(proyecto.balance.toStringAsFixed(2))}",
                                style: TextStyle(
                                  color: proyecto.balance >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),

                            /// STATUS
                            DataCell(buildEstadoBadge(proyecto.status)),

                            /// ACCIONES
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    tooltip: "Ver proyecto",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenDetailsProyecto(
                                                proyecto: proyecto,
                                              ),
                                        ),
                                      );
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: "Editar",
                                    onPressed: () {},
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.analytics),
                                    tooltip: "Analizar",
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
