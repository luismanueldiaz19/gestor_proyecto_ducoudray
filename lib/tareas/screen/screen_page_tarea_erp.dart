import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../palletes/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_loading.dart';
import '../model/tarea_historia.dart';
import '../model/tarea_pendientes.dart';
import '../provider_tareas/tarea_provider.dart';
import 'mostrador_tiempos.dart';

class ScreenPageTareaERP extends StatefulWidget {
  const ScreenPageTareaERP({super.key});

  @override
  State createState() => _ScreenPageTareaERPState();
}

class _ScreenPageTareaERPState extends State<ScreenPageTareaERP> {
  final TextEditingController _conTitulo = TextEditingController();
  final TextEditingController _conUsuario = TextEditingController();
  final TextEditingController _conFecha = TextEditingController();

  void clearFilters() {
    final pedidoProvider = Provider.of<TareaProvider>(context, listen: false);
    // final pedidoItem = context.watch<PedidoProvider>();
    _conTitulo.clear();
    _conUsuario.clear();

    _conFecha.clear();
    pedidoProvider.cleanAll();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((state) {
      Provider.of<TareaProvider>(
        context,
        listen: false,
      ).setUsuarioServer(currentUsuario!.nombreCompleto!);
      Provider.of<TareaProvider>(context, listen: false).fetchTareas();
    });
  }

  Future comentar(TareaPendiente? newValue) async {
    await Provider.of<TareaProvider>(
      context,
      listen: false,
    ).actualizarTarea(context, newValue!.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<TareaProvider>(context);
    final pedidoItem = context.watch<TareaProvider>();

    final style = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Mis Tareas',
            style: style.titleLarge?.copyWith(color: AppColors.tealGreen),
          ),
        ),

        pedidoItem.listadoPendienteFiltros.isNotEmpty
            ? Expanded(
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
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('USUARIO')),
                          DataColumn(label: Text('FECHA TAREAS')),
                          DataColumn(label: Text('TITULO')),
                          DataColumn(label: Text('DETALLES')),
                          DataColumn(label: Text('HORAS')),

                          DataColumn(label: Text('TASKING')),
                        ],
                        rows: pedidoItem.listadoPendienteFiltros
                            .asMap()
                            .entries
                            .map((entry) {
                              int index = entry.key;
                              var report = entry.value;
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color>((
                                  Set<WidgetState> states,
                                ) {
                                  if (index.isOdd) {
                                    return Colors.grey.shade300;
                                  }
                                  return Colors.white;
                                }),
                                cells: [
                                  DataCell(Text(report.tareaId ?? 'N/A')),
                                  DataCell(
                                    Text(
                                      limitarTexto(
                                        report.hechoPor ?? 'N/A',
                                        15,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      report.creadoEn.toString().substring(
                                        0,
                                        10,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(report.titulo!.toUpperCase())),
                                  DataCell(
                                    limitaTextTool(
                                      context,
                                      report.descripcion ?? 'N/A',
                                      25,
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        Text(
                                          getTimeRelationProporcional(
                                            report.horas ?? 0.0,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return MostradorTiempos(
                                                  item: TareaHistoria.fromJson(
                                                    report.toJson(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.list_alt_rounded),
                                        ),
                                      ],
                                    ),
                                  ),

                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          transitionBuilder:
                                              (child, animation) {
                                                return ScaleTransition(
                                                  scale: animation,
                                                  child: child,
                                                );
                                              },
                                          child: ElevatedButton.icon(
                                            // La clave asegura que AnimatedSwitcher detecte el cambio
                                            key: ValueKey<bool>(
                                              report.tiempoAbierto!,
                                            ),
                                            onPressed: report.tiempoAbierto!
                                                ? () => pedidoProvider
                                                      .terminarTiempo(
                                                        context,
                                                        report.tareaId,
                                                      )
                                                : () => pedidoProvider
                                                      .iniciarTiempo(
                                                        context,
                                                        report.tareaId,
                                                      ),
                                            icon: Icon(
                                              report.tiempoAbierto!
                                                  ? Icons.stop
                                                  : Icons.play_arrow,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              report.tiempoAbierto!
                                                  ? 'Parar'
                                                  : 'Iniciar',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  report.tiempoAbierto!
                                                  ? Colors.red
                                                  : Colors.green,
                                              minimumSize: const Size(120, 40),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: CustomLoading(
                  scale: 15,
                  text: 'No hay tareas disponibles',
                  imagen: 'assets/plan.png',
                ),
              ),
      ],
    );
  }
}
