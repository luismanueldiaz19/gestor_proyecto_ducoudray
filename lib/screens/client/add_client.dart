import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/cliente.dart';
import '../../provider/cliente_provider.dart';

void mostrarDialogAgregarCliente(BuildContext context) {
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String tipoCliente = 'individual';
  showDialog(
    context: context,
    builder: (context) {
      final style = Theme.of(context).textTheme;
      return AlertDialog(
        title: Text("Agregar Cliente", style: style.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),

                _buildText(telefonoController, 'Teléfono *'),
                _buildText(direccionController, 'Dirección (Opcional)'),
                _buildText(emailCtrl, 'Email (Opcional)'),
                _buildDropdown(
                  'Tipo Cliente',
                  tipoCliente,
                  ['corporativo', 'pyme', 'individual'],
                  (v) {
                    tipoCliente = v;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            child: const Text("Guardar"),
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                // Si pasa la validación
                final cliente = Cliente(
                  nombre: nombreController.text.trim(),
                  direccion: direccionController.text.isEmpty
                      ? "N/A"
                      : direccionController.text.trim(),
                  telefono: telefonoController.text.isEmpty
                      ? "N/A"
                      : telefonoController.text.trim(),
                  email: emailCtrl.text.isNotEmpty
                      ? emailCtrl.text.trim()
                      : "N/A",
                  tipoCliente: tipoCliente.trim(),
                );

                bool success = await enviarCliente(cliente, context);
                Navigator.pop(context, true);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: success ? Colors.green : Colors.red,
                    content: Text(
                      success
                          ? 'Cliente agregado correctamente'
                          : 'Error al agregar cliente',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Widget _buildText(
  TextEditingController ctrl,
  String label, {
  bool required = false,
  TextInputType? type,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (required && (v == null || v.isEmpty)) return 'Requerido';
        return null;
      },
    ),
  );
}

Widget _buildDropdown(
  String label,
  String value,
  List<String> items,
  Function(String) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: DropdownButtonFormField(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v as String),
      decoration: InputDecoration(labelText: label),
    ),
  );
}

Future<bool> enviarCliente(Cliente client, context) async {
  return Provider.of<ClienteProvider>(
    context,
    listen: false,
  ).addCliente(client);
}
