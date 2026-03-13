import 'package:ducoudray/model/usuario.dart';
import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/roles.dart';
import '../../repositories/usuarios_services.dart';
import '../../widgets/buscador_dialog.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/validar_screen_available.dart';
import 'get_dialog_roles.dart';

class ScreenUsuarios extends StatefulWidget {
  const ScreenUsuarios({super.key});

  @override
  State createState() => _ScreenUsuariosState();
}

class _ScreenUsuariosState extends State<ScreenUsuarios> {
  UsuariosServices permissions = UsuariosServices();

  bool isLoading = true;
  List<Usuario> _list = [];
  List<Usuario> _listFilter = [];
  Future getReporteMensual() async {
    try {
      setState(() {
        isLoading = true;
      });
      _list = await permissions.getAllUsuarios();
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

  final _contLinea = TextEditingController();

  String? nombreCompleto;

  cleanAll() {
    _contLinea.clear();
    _listFilter = _list;
    setState(() {});
  }

  void setFilterNombre(val) {
    nombreCompleto = val;
    applyFilter();
  }

  void applyFilter() {
    _listFilter = _list.where((item) {
      bool matches = true;

      if (nombreCompleto != null && nombreCompleto!.isNotEmpty) {
        matches =
            matches &&
            (nombreCompleto?.toLowerCase() ==
                item.nombreCompleto?.toLowerCase());
      }

      return matches;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidget = isLoading
        ? const Center(child: CircularProgressIndicator())
        : _listFilter.isEmpty
        ? const Center(child: Text("No hay usuarios disponibles"))
        : Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: _listFilter.length,
              itemBuilder: (context, index) {
                return UsuarioCard(
                  usuario: _listFilter[index],
                  updateRol: updateRol,
                );

                //  buildRoleCard(_listFilter[index]);
              },
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Roles y Permisos de usuario"),
      ),
      body: ValidarScreenAvailable(
        windows: Column(
          children: [
            const SizedBox(width: double.infinity),
            textFieldWidgetUI(
              label: 'Buscar Usuario',
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BuscadorDialog(
                      items: Usuario.getUniqueNombreCompleto(_list),
                      onSelected: (value) {
                        _contLinea.text = value;
                        setFilterNombre(value);
                      },
                    );
                  },
                );
              },
              controller: _contLinea,
              suffixIcon: Icons.close,
              onSuffixTap: () {
                cleanAll();
              },
            ),
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
                        DataColumn(label: Text('Nombres')),
                        DataColumn(label: Text('Usuarios')),
                        DataColumn(label: Text('Permisos')),
                        DataColumn(label: Text('Roles')),
                        DataColumn(label: Text('Vehiculos')),
                        DataColumn(label: Text('Acciones')),
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
                            DataCell(Text(items.nombreCompleto ?? 'N/A')),
                            DataCell(Text(items.usuario ?? 'N/A')),
                            DataCell(
                              limitaTextTool(
                                context,
                                items.permisos!
                                    .map((e) => e)
                                    .toSet()
                                    .toString(),
                                15,
                              ),
                            ),
                            DataCell(
                              limitaTextTool(
                                context,
                                items.roles!.map((e) => e).toSet().toString(),
                                15,
                              ),
                            ),
                            DataCell(limitaTextTool(context, items.status, 15)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Seleccionar nuevos roles',
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      final List<Roles>? selectedRoles =
                                          await showRollesDialog(context);

                                      if (selectedRoles != null &&
                                          selectedRoles.isNotEmpty) {
                                        final List<int> roleIds = selectedRoles
                                            .map((r) => r.rolId)
                                            .toList();

                                        if (updateRol != null) {
                                          updateRol!(
                                            int.parse(items.usuarioId ?? ''),
                                            roleIds,
                                          );
                                        }
                                      }
                                    },
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
            ),
            identy(context),
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

  void updateRol(int usuarioId, List<int> roleIds) async {
    // Aquí llamas a tu servicio API para actualizar roles
    print('Aquí llamas a tu servicio API para actualizar roles');
    bool? value = await permissions.updateUserRoles(usuarioId, roleIds);
    if (value) {
      getReporteMensual();
    }
  }
}

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final Function? updateRol;

  const UsuarioCard({
    super.key,
    required this.usuario,
    required this.updateRol,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Encabezado con nombre y estado
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    usuario.nombreCompleto ?? 'Sin nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tooltip(
                  message: usuario.status == 't' || usuario.status == 'true'
                      ? 'Usuario activo'
                      : 'Usuario deshabilitado',
                  child: Icon(
                    usuario.status == 't' || usuario.status == 'true'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: usuario.status == 't' || usuario.status == 'true'
                        ? Colors.green
                        : Colors.red,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// Usuario (nickname)
            Row(
              children: [
                const Icon(Icons.account_circle, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  usuario.usuario ?? 'Sin usuario',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Roles
            const Text("Roles:", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 6,
              runSpacing: -4,
              children: usuario.roles!
                  .map(
                    (rol) => Chip(
                      label: Text(
                        rol,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            /// Permisos
            const Text(
              "Permisos:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: usuario.permisos!
                  .map(
                    (permiso) => Row(
                      children: [
                        const Icon(
                          Icons.lock_open,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(permiso),
                      ],
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            /// Acciones
            Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Cambiar rol de usuario',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  tooltip: 'Seleccionar nuevos roles',
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () async {
                    final List<Roles>? selectedRoles = await showRollesDialog(
                      context,
                    );

                    if (selectedRoles != null && selectedRoles.isNotEmpty) {
                      final List<int> roleIds = selectedRoles
                          .map((r) => r.rolId)
                          .toList();

                      if (updateRol != null) {
                        updateRol!(int.parse(usuario.usuarioId ?? ''), roleIds);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class UsuarioCard extends StatelessWidget {
//   final Usuario usuario;

//   final Function? updateRol;
//   const UsuarioCard(
//       {super.key, required this.usuario, required this.updateRol});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Nombre del usuario
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   '# ${usuario.usuarioId.toString()}',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   usuario.nombreCompleto ?? 'Sin nombre',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),

//             /// Usuario (nickname)
//             Text(
//               usuario.usuario ?? 'Sin usuario',
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//               ),
//             ),

//             const SizedBox(height: 8),

//             /// Estado del usuario
//             Row(
//               children: [
//                 const Text('Estado: '),
//                 Tooltip(
//                   message: usuario.status == true
//                       ? 'Usuario Activo'
//                       : 'Este usuario esta deshabilitado',
//                   child: Icon(
//                     usuario.status == true ? Icons.check_circle : Icons.cancel,
//                     color: usuario.status == true ? Colors.green : Colors.red,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// Roles
//             const Text("Roles:", style: TextStyle(fontWeight: FontWeight.bold)),
//             Wrap(
//               spacing: 8,
//               children: usuario.roles
//                   .map((rol) => Chip(
//                       label: Text(
//                         rol,
//                         style: TextStyle(color: Colors.white60),
//                       ),
//                       backgroundColor: AppColors.primary))
//                   .toList(),
//             ),

//             const SizedBox(height: 12),

//             /// Permisos
//             const Text("Permisos:",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: usuario.permisos
//                   .map((permiso) => Row(
//                         children: [
//                           const Icon(Icons.lock_open,
//                               size: 16, color: Colors.grey),
//                           const SizedBox(width: 6),
//                           Text(permiso),
//                         ],
//                       ))
//                   .toList(),
//             ),
// // AsignarVehiculos
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Icon(Icons.admin_panel_settings,
//                     color: Colors.blueAccent),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     'Cambiar rol de usuario',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   tooltip: 'Seleccionar nuevos roles',
//                   icon: const Icon(Icons.edit, color: Colors.grey),
//                   onPressed: () async {
//                     final List<Roles>? selectedRoles =
//                         await showRollesDialog(context);

//                     if (selectedRoles != null && selectedRoles.isNotEmpty) {
//                       final List<int> roleIds =
//                           selectedRoles.map((r) => r.rolId).toList();

//                       print('Usuario ID: ${usuario.usuarioId}');
//                       print('Roles seleccionados: $roleIds');

//                       if (updateRol != null) {
//                         updateRol!(usuario.usuarioId,
//                             roleIds); // <== Aquí se pasa el id y la lista
//                       }
//                     }
//                   },
//                 ),
//                 IconButton(
//                   tooltip: 'Asignar Vehiculos',
//                   icon:
//                       const Icon(Icons.car_repair_outlined, color: Colors.blue),
//                   onPressed: () async {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               AsignarVehiculos(usuario: usuario)),
//                     );
//                     // final List<Roles>? selectedRoles =
//                     //     await showRollesDialog(context);

//                     // if (selectedRoles != null && selectedRoles.isNotEmpty) {
//                     //   final List<int> roleIds =
//                     //       selectedRoles.map((r) => r.rolId).toList();

//                     //   print('Usuario ID: ${usuario.usuarioId}');
//                     //   print('Roles seleccionados: $roleIds');

//                     //   if (updateRol != null) {
//                     //     updateRol!(usuario.usuarioId,
//                     //         roleIds); // <== Aquí se pasa el id y la lista
//                     //   }
//                     // }
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
