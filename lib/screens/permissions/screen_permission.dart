import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/repositories/permission_services.dart';
import 'package:ducoudray/utils/helpers.dart';
import 'package:ducoudray/widgets/validar_screen_available.dart';
import 'package:flutter/material.dart';
import '../../model/roles.dart';

class ScreenPermission extends StatefulWidget {
  const ScreenPermission({super.key});

  @override
  State createState() => _ScreenPermissionState();
}

class _ScreenPermissionState extends State<ScreenPermission> {
  PermissionServices permissions = PermissionServices();
  bool isLoading = true;
  List<Roles> _list = [];
  List<Roles> _listFilter = [];
  Future getReporteMensual() async {
    try {
      _list = await permissions.getRolesAndPermissions();

      setState(() {
        _listFilter = _list;
        isLoading = false;
      });
    } catch (e) {
      // throw Exception("Error al cargar roles");
    }
  }

  @override
  void initState() {
    super.initState();
    getReporteMensual();
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidget = isLoading
        ? const Center(child: CircularProgressIndicator())
        : _listFilter.isEmpty
        ? const Center(child: Text("No hay roles disponibles"))
        : Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: _listFilter.length,
              itemBuilder: (context, index) {
                return buildRoleCard(_listFilter[index]);
              },
            ),
          );

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Roles y Permisos")),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            const SizedBox(width: double.infinity),
            Expanded(
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
                      ),
                      headingRowHeight: 42,
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnSpacing: 22,
                      horizontalMargin: 12,
                      columns: const [
                        DataColumn(label: Text('#ID')),
                        DataColumn(label: Text('ROLES')),
                        DataColumn(label: Text('DETALLES')),
                        DataColumn(label: Text('Permisos')),
                      ],
                      rows: _listFilter.asMap().entries.map((entry) {
                        int index = entry.key;
                        var items = entry.value;
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
                            DataCell(Text(items.rolId.toString())),
                            DataCell(Text(items.nombre ?? 'N/A')),
                            DataCell(Text(items.descripcion ?? 'N/A')),
                            DataCell(
                              limitaTextTool(
                                context,
                                Permiso.getUniquePermisos(
                                  items.permisos,
                                ).join(','),
                                15,
                                title: 'Listado de acciones/permisos',
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
        mobile: Column(
          children: [
            Expanded(child: mobileWidget),
            identy(context),
          ],
        ),
      ),
    );
  }

  Widget buildRoleCard(Roles role) {
    return SizedBox(
      width: 350,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(role.descripcion),
              const SizedBox(height: 12),
              const Text(
                "Permisos:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: role.permisos.map((permiso) {
                  return Chip(
                    label: Text(
                      permiso.nombre,
                      style: TextStyle(color: Colors.white60),
                    ),
                    backgroundColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
