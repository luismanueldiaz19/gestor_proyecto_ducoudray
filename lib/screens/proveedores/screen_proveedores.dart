import 'package:flutter/material.dart';
import '../../screens/proveedores/add_proveedores.dart';
import '../../utils/helpers.dart';

import '../../model/proveedor.dart';
import '../../repositories/proveedor_repositories.dart';
import '../../utils/constants.dart';

class ScreenProveedores extends StatefulWidget {
  const ScreenProveedores({super.key});

  @override
  State createState() => _ScreenProveedoresState();
}

class _ScreenProveedoresState extends State<ScreenProveedores> {
  bool isLoading = false;
  List<Proveedor> _list = [];
  List<Proveedor> _listFilter = [];

  Future<void> loadFetch() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final data = await ProveedorRepositories.fetchProveedor();
      setState(() {
        _list = data;
        _listFilter = _list;
        isLoading = false; // importante: liberar el estado
      });
    } catch (e) {
      print(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadFetch();
  }

  List<T> filtrarPor<T>(List<T> lista, bool Function(T elemento) criterio) {
    return lista.where(criterio).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity, height: 10),
          textFieldWidgetUI(
            label: 'Buscar',
            hintText: 'Buscar Proveedor',
            onChanged: (value) {
              _listFilter = filtrarPor(_list, (elemento) {
                return elemento.nombreProveedor
                    .toString()
                    .toLowerCase()
                    .contains(value);
              });
              setState(() {});
            },
          ),
          if (_listFilter.isNotEmpty)
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
                      DataColumn(label: Text('Nombre Proveedores')),
                      DataColumn(label: Text('Telefono')),
                      DataColumn(label: Text('Rnc')),
                      DataColumn(label: Text('Dirección')),
                      DataColumn(label: Text('Tipo')),
                      if (currentUsuario!.tienePermiso('crear_proveedores'))
                        DataColumn(label: Text('Editar')),
                    ],
                    rows: _listFilter.asMap().entries.map((entry) {
                      final index = entry.key;
                      final v = entry.value;

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
                          DataCell(Text(v.nombreProveedor ?? 'N/A')),
                          DataCell(Text(v.telefono ?? 'N/A')),
                          DataCell(Text(v.rnc ?? 'N/A')),
                          DataCell(
                            limitaTextTool(
                              context,
                              v.direccion ?? 'N/A',
                              25,
                              title: 'Dirección',
                            ),
                          ),
                          DataCell(
                            Center(child: Text(v.tipoProveedor ?? 'N/A')),
                          ),
                          if (currentUsuario!.tienePermiso('crear_proveedores'))
                            DataCell(
                              Text('Editar'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddProveedores(proveedor: v),
                                  ),
                                );
                              },
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
