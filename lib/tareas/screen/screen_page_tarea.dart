import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../palletes/app_colors.dart';
import '../../services/print_services.dart';
import '../../utils/constants.dart';
import '../../utils/dynamic_form.dart';
import '../../utils/helpers.dart';
import '../../widgets/buscador_dialog.dart';
import '../../widgets/custom_loading.dart';
import '../model/tarea_historia.dart';
import '../model/tarea_pendientes.dart';
import '../printer/imprimir_tareas.dart';
import '../provider_tareas/tarea_provider.dart';
import 'add_tarea.dart';
import 'mostrador_tiempos.dart';

class ScreenPageTarea extends StatefulWidget {
  const ScreenPageTarea({super.key});

  @override
  State createState() => _ScreenPageTareaState();
}

class _ScreenPageTareaState extends State<ScreenPageTarea> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiempo de tareas'),
        actions: [
          if (currentUsuario!.tienePermiso('administrador'))
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextIconButton(
                width: 250,
                onPressed: () {
                  pedidoProvider.cleanUsuarioServer();
                  pedidoProvider.fetchTareas();
                },
                icon: Icons.remove_red_eye_outlined,
                text: 'Ver asignación de todos',
                colorButton: Colors.transparent,
                textColor: AppColors.error,
              ),
            ),
          pedidoItem.listadoPendienteFiltros.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: IconButton(
                    onPressed: () async {
                      final doc = await ImprimirTareas.generate(
                        pedidoItem.listadoPendienteFiltros,
                      );
                      await PdfApi.openFile(doc);
                    },
                    icon: const Icon(Icons.print),
                  ),
                )
              : const SizedBox(),
          if (currentUsuario!.tienePermiso('ver_tarea'))
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTarea()),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity),
          if (pedidoItem.listadoPendiente.isNotEmpty)
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
                            items: TareaPendiente.getUniqueFecha(
                              pedidoItem.listadoPendiente,
                            ),
                            onSelected: (value) {
                              _conFecha.text = value;
                              pedidoProvider.setFilterFecha(value);
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
                            items: TareaPendiente.getUniqueTitulos(
                              pedidoItem.listadoPendienteFiltros,
                            ),
                            onSelected: (value) {
                              _conTitulo.text = value;
                              pedidoProvider.setFilterTitulo(value);
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
                            items: TareaPendiente.getUniqueUsuario(
                              pedidoItem.listadoPendienteFiltros,
                            ),
                            onSelected: (value) {
                              _conUsuario.text = value;
                              pedidoProvider.setFilterUsuario(value);
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
                            DataColumn(label: Text('TIEMPOS')),
                            DataColumn(label: Text('TASKING')),
                            if (currentUsuario!.tienePermiso('crear_tarea'))
                              DataColumn(label: Text('ACCION')),
                            if (currentUsuario!.tienePermiso('administrador'))
                              DataColumn(label: Text('QUITAR')),
                            DataColumn(label: Text('COMENTARIO')),
                            DataColumn(label: Text('REGISTRADO POR')),
                          ],
                          rows: pedidoItem.listadoPendienteFiltros.asMap().entries.map((
                            entry,
                          ) {
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
                                    limitarTexto(report.hechoPor ?? 'N/A', 15),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    report.creadoEn.toString().substring(0, 10),
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
                                DataCell(Text(report.hasTiempo ?? 'N/A')),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder: (child, animation) {
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
                                if (currentUsuario!.tienePermiso('crear_tarea'))
                                  report.tiempoAbierto!
                                      ? DataCell(Text(''))
                                      : DataCell(
                                          Text("FINALIZAR"),
                                          onTap: () {
                                            final newValue = report.copyWith(
                                              estado: 'completado',
                                            );
                                            pedidoProvider.actualizarTarea(
                                              context,
                                              newValue.toJson(),
                                            );
                                          },
                                        ),
                                if (currentUsuario!.tienePermiso(
                                  'administrador',
                                ))
                                  DataCell(
                                    Text("QUITAR"),
                                    onTap: () => pedidoProvider.removeTarea(
                                      context,
                                      report.tareaId,
                                    ),
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
                                            TareaPendiente? newValue;
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
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoading(
                        scale: 6,
                        text: 'No hay tareas disponibles',
                        imagen: 'assets/plan.png',
                      ),
                      if (currentUsuario!.tienePermiso('administrador'))
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextIconButton(
                            width: 250,
                            onPressed: () {
                              pedidoProvider.cleanUsuarioServer();
                              pedidoProvider.fetchTareas();
                            },
                            icon: Icons.remove_red_eye_outlined,
                            text: 'Ver asignación de todos',
                            colorButton: Colors.transparent,
                            textColor: AppColors.error,
                          ),
                        ),
                    ],
                  ),
                ),
          if (pedidoItem.listadoPendienteFiltros.isNotEmpty)
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
                      pedidoItem.listadoPendienteFiltros.length.toString(),
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
}
