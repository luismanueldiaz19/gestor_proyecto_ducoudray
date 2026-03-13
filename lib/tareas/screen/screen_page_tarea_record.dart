import 'package:ducoudray/utils/helpers.dart';
import 'package:ducoudray/widgets/mes_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/print_services.dart';
import '../../utils/constants.dart';
import '../../utils/dynamic_form.dart';
import '../../widgets/buscador_dialog.dart';
import '../../widgets/custom_loading.dart';
import '../model/tarea_historia.dart';
import '../printer/imprimir_tareas_historia.dart';
import '../provider_tareas/tarea_provider.dart';
import '../repositories/tarea_repositories.dart';
import 'mostrador_tiempos.dart';

class ScreenPageTareaRecord extends StatefulWidget {
  const ScreenPageTareaRecord({super.key});

  @override
  State createState() => _ScreenPageTareaRecordState();
}

class _ScreenPageTareaRecordState extends State<ScreenPageTareaRecord> {
  String date1 = DateTime.now().toString().substring(0, 10);
  String date2 = DateTime.now().toString().substring(0, 10);
  final TextEditingController _conTitulo = TextEditingController();
  final TextEditingController _conUsuario = TextEditingController();
  final TextEditingController _conFecha = TextEditingController();
  List<TareaHistoria> _list = [];
  List<TareaHistoria> _listFilter = [];

  String? tituloPicked;
  String? usuarioPicked;
  String? fechaPicked;

  @override
  void initState() {
    super.initState();
    fetchTareas();
  }

  Future comentar(TareaHistoria? newValue) async {
    await Provider.of<TareaProvider>(
      context,
      listen: false,
    ).actualizarTarea(context, newValue!.toJson());
    fetchTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de tiempo de tareas'),
        actions: [
          _listFilter.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: IconButton(
                    onPressed: () async {
                      final doc = await ImprimirTareasHistorial.generate(
                        _listFilter,
                      );
                      await PdfApi.openFile(doc);
                    },
                    icon: const Icon(Icons.print),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () async {
                await selectDateRange(context, (fecha1, fecha2) {
                  date1 = fecha1;
                  date2 = fecha2;
                  fetchTareas();
                });
              },
              icon: Icon(Icons.calendar_month),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          MesSelectorWidget(
            onMesSeleccionado: (mesIndex, mesNombre, rango) async {
              date1 = rango['inicio'].toString().substring(0, 10);
              date2 = rango['fin'].toString().substring(0, 10);
              fetchTareas();
            },
          ),
          if (_list.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  textFieldWidgetUI(
                    controller: _conFecha,
                    width: 150,
                    hintText: 'Ingrese Fecha',
                    label: 'Buscar Fecha',
                    readOnly: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BuscadorDialog(
                            items: TareaHistoria.getUniqueFecha(_list),
                            onSelected: (value) {
                              _conFecha.text = value;
                              setFilterFecha(value);
                            },
                          );
                        },
                      );
                    },
                  ),
                  textFieldWidgetUI(
                    controller: _conTitulo,
                    width: 150,
                    hintText: 'Ingrese Titulo',
                    label: 'Buscar Titulo',
                    readOnly: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BuscadorDialog(
                            items: TareaHistoria.getUniqueTitulos(_listFilter),
                            onSelected: (value) {
                              _conTitulo.text = value;
                              setFilterTitulo(value);
                            },
                          );
                        },
                      );
                    },
                  ),
                  textFieldWidgetUI(
                    controller: _conUsuario,
                    width: 150,
                    hintText: 'Ingrese Usuario',
                    label: 'Buscar Usuario',
                    readOnly: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BuscadorDialog(
                            items: TareaHistoria.getUniqueUsuario(_listFilter),
                            onSelected: (value) {
                              _conUsuario.text = value;
                              setFilterUsuario(value);
                            },
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () => clearFilters(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          _listFilter.isEmpty
              ? Expanded(child: CustomLoading(text: 'no hay datos', scale: 10))
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
                          border: TableBorder.all(color: Colors.grey.shade300),

                          columnSpacing: 22,
                          horizontalMargin: 12,
                          columns: [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('TITULO')),
                            DataColumn(label: Text('DETALLES TAREAS')),
                            DataColumn(label: Text('USUARIO')),
                            DataColumn(label: Text('HORAS')),
                            DataColumn(label: Text('FECHA')),
                            DataColumn(label: Text('TIEMPOS')),
                            DataColumn(label: Text('COMENTARIO')),
                            DataColumn(label: Text('REGISTRADO')),
                            if (currentUsuario!.tienePermiso('administrador'))
                              DataColumn(label: Text('QUITAR')),
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
                                DataCell(Text(report.tareaId ?? 'N/A')),
                                DataCell(Text(report.titulo ?? 'N/A')),
                                DataCell(
                                  limitaTextTool(
                                    context,
                                    report.descripcion ?? 'N/A',
                                    25,
                                  ),
                                ),
                                DataCell(Text(report.hechoPor ?? 'N/A')),
                                DataCell(
                                  Text(
                                    getTimeRelationProporcional(
                                      report.horas ?? 0.0,
                                    ),
                                  ),
                                ),
                                DataCell(Text(report.creadoEn ?? 'N/A')),
                                DataCell(
                                  Text('VER TIEMPOS'),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return MostradorTiempos(item: report);
                                      },
                                    );
                                  },
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: limitaTextTool(
                                          context,
                                          report.feedback ?? 'N/A',
                                          5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: IconButton.filled(
                                          onPressed: () async {
                                            TareaHistoria? newValue;
                                            final camposCategories = [
                                              {
                                                "name": "feedback",
                                                "label": "Escribir comentario",
                                                "type": "text",
                                                "required": true,
                                              },
                                            ];
                                            await showDialog(
                                              context: context,
                                              builder: (_) => DynamicForm(
                                                fields: camposCategories,
                                                title: 'Escribir comentario',
                                                onSave: (data) async {
                                                  print(data);
                                                  String nuevoMensaje =
                                                      report.feedback != null &&
                                                          report.feedback !=
                                                              'N/A'
                                                      ? '${report.feedback} ,${data['feedback']} (${currentUsuario?.nombreCompleto}) at ${DateTime.now().toString().substring(0, 19)}.'
                                                      : data['feedback'];
                                                  newValue = report.copyWith(
                                                    feedback: nuevoMensaje,
                                                  );
                                                },
                                              ),
                                            );
                                            if (newValue != null) {
                                              await comentar(newValue!);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.comment_outlined,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(report.registedBy ?? 'N/A')),
                                if (currentUsuario!.tienePermiso(
                                  'administrador',
                                ))
                                  DataCell(
                                    Text("QUITAR"),
                                    onTap: () =>
                                        removeTarea(context, report.tareaId),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          if (_listFilter.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildTotalBox(
                      'Tareas ',
                      _listFilter.length.toString(),
                      Colors.brown,
                      context,
                    ),
                  ],
                ),
              ),
            ),
          identy(context),
        ],
      ),
    );
  }

  Future<void> fetchTareas() async {
    try {
      _list.clear();
      _listFilter.clear();

      final listaFetch = await TareaRepositories.getTareaHistoria({
        'date1': date1,
        'date2': date2,
      });

      if (currentUsuario!.tienePermiso('administrador')) {
        _list = listaFetch;
        _listFilter = listaFetch;
      } else {
        _listFilter = listaFetch
            .where(
              (test) =>
                  test.registedBy?.toUpperCase() ==
                  currentUsuario?.nombreCompleto?.toUpperCase(),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('Error al obtener reportes: $e');
      _listFilter = [];
      _list = [];
    }
    setState(() {});
  }

  setFilterTitulo(String value) {
    tituloPicked = value;
    filterTarea();
    notifyListeners();
  }

  setFilterUsuario(String value) {
    usuarioPicked = value;
    filterTarea();
    notifyListeners();
  }

  setFilterFecha(String fecha) {
    fechaPicked = fecha;
    filterTarea();
    notifyListeners();
  }

  clearFilters() {
    tituloPicked = null;
    usuarioPicked = null;
    fechaPicked = null;
    _listFilter = _list;
    notifyListeners();
  }

  notifyListeners() {
    setState(() {});
  }

  void filterTarea() {
    _listFilter = _list.where((pedido) {
      bool matches = true;

      if (fechaPicked != null && fechaPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.creadoEn?.toString().substring(0, 10).toLowerCase() ==
                fechaPicked!.toLowerCase());
      }
      if (tituloPicked != null && tituloPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.titulo?.toLowerCase() == tituloPicked!.toLowerCase());
      }

      if (usuarioPicked != null && usuarioPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.hechoPor?.toLowerCase() == usuarioPicked!.toLowerCase());
      }

      return matches;
    }).toList();
    // print('Tamano de la lista Pedido currentes : ${_pedidosFiltrados.length}');
  }

  removeTarea(context, id) async {
    bool? ask = await showConfirmationDialogOnyAsk(context, eliminarMjs);

    if (ask != null && ask == true) {
      try {
        bool? value = await TareaRepositories.elimninarTarea({"tarea_id": id});
        if (value == true) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }
}
