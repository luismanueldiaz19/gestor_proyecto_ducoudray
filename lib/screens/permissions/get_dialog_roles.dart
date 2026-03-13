import 'package:flutter/material.dart';
import '../../model/roles.dart';
import '../../repositories/permission_services.dart';

Future showRollesDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => _MultiSelectRolesDialog(),
  );
}

class _MultiSelectRolesDialog extends StatefulWidget {
  @override
  State<_MultiSelectRolesDialog> createState() =>
      _MultiSelectRolesDialogState();
}

class _MultiSelectRolesDialogState extends State<_MultiSelectRolesDialog> {
  final PermissionServices permissions = PermissionServices();
  List<Roles> availableRoles = [];
  final Set<Roles> selectedRoles = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  Future<void> loadRoles() async {
    try {
      availableRoles = await permissions.getRolesAndPermissions();
    } catch (e) {
      // Opcional: manejar errores de red
      print("Error al cargar roles: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      title: Text('Seleccionar Roles', style: style.bodyMedium),
      content: isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : availableRoles.isEmpty
              ? const Text('No hay roles disponibles.')
              : SizedBox(
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableRoles.length,
                    itemBuilder: (context, index) {
                      final rol = availableRoles[index];
                      final isSelected = selectedRoles.contains(rol);
                      return CheckboxListTile(
                        title: Text(rol.nombre),
                        subtitle: Text(rol.descripcion),
                        value: isSelected,
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              selectedRoles.add(rol);
                            } else {
                              selectedRoles.remove(rol);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancelar
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pop(selectedRoles.toList()), // Confirmar
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
