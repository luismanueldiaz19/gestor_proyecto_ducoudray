import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/cliente.dart';
import '../../provider/cliente_provider.dart';
import '../../repositories/cliente_service.dart';
import '../../utils/constants.dart';
import '../../utils/dynamic_form.dart';
import '../../utils/helpers.dart';
import '../../widgets/buscador_dialog.dart';
import 'add_client.dart';

class ScreenListCliente extends StatefulWidget {
  const ScreenListCliente({super.key});

  @override
  State createState() => _ScreenListClienteState();
}

class _ScreenListClienteState extends State<ScreenListCliente> {
  final _conSurcu = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callBack) {
      Provider.of<ClienteProvider>(context, listen: false).fetchClientes();
    });
  }

  List<T> filtrarPor<T>(List<T> lista, bool Function(T elemento) criterio) {
    return lista.where(criterio).toList();
  }

  void actualizatItem(Cliente item) async {
    print(item.toJson());
    final camposCategories = [
      {
        "name": "nombre",
        "label": "Nombre del cliente",
        "type": "text",
        "required": true,
      },
      {
        "name": "direccion",
        "label": "Dirección",
        "type": "text",
        "required": true,
      },
      {
        "name": "telefono",
        "label": "Telefono",
        "type": "number",
        "required": true,
      },
    ];
    await showDialog(
      context: context,
      builder: (_) => DynamicForm(
        fields: camposCategories,
        initialData: item.toJson(),
        title: 'Cliente',
        onSave: (data) async {
          print(data);
          data['cliente_id'] = item.clienteId.toString();
          print(data);
          await ClienteService.actualizarCliente(Cliente.fromJson(data));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.read<ClienteProvider>();

    final watchList = context.watch<ClienteProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de clientes'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ClienteProvider>(
                context,
                listen: false,
              ).fetchClientes();
            },
            icon: Icon(Icons.replay),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                mostrarDialogAgregarCliente(context);
              },
              icon: Icon(Icons.group_add_sharp),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(width: double.infinity, height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: [
                textFieldWidgetUI(
                  controller: _conSurcu,
                  hintText: 'Ingrese Sucursal',
                  label: 'Buscar Sucursal',
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BuscadorDialog(
                          items: Cliente.getUniqueCliente(
                            clienteProvider.clientesOriginal,
                          ),
                          onSelected: (value) {
                            _conSurcu.text = value;
                            clienteProvider.setFilterCliente(value);
                          },
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    _conSurcu.clear();
                    clienteProvider.clearFilters();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (watchList.clientes.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    headingRowHeight: 42,
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnSpacing: 22,
                    horizontalMargin: 12,
                    columns: [
                      DataColumn(label: Text('#ID')),
                      DataColumn(label: Text('NOMBRE CLIENTE')),
                      DataColumn(label: Text('TELEFONO')),
                      DataColumn(label: Text('DIRECCION')),
                      if (currentUsuario!.tienePermiso('crear_clientes'))
                        DataColumn(label: Text('EDITAR')),
                    ],
                    rows: clienteProvider.clientes.asMap().entries.map((entry) {
                      final index = entry.key;
                      Cliente v = entry.value;

                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>((
                          states,
                        ) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.blue.shade50; // hover
                          }
                          return index.isEven
                              ? Colors.white
                              : Colors.grey.shade200;
                        }),
                        cells: [
                          DataCell(Text(v.clienteId.toString())),
                          DataCell(Text(v.nombre ?? 'N/A')),
                          DataCell(Text(v.telefono ?? 'N/A')),
                          DataCell(
                            limitaTextTool(
                              context,
                              v.direccion ?? 'N/A',
                              15,
                              title: 'Dirección',
                            ),
                          ),
                          if (currentUsuario!.tienePermiso('crear_clientes'))
                            DataCell(
                              Text('Editar'),
                              onTap: () => actualizatItem(v),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          identy(context),
        ],
      ),
    );
  }
}
