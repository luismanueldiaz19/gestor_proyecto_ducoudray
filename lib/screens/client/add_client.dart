import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/cliente.dart';
import '../../provider/cliente_provider.dart';


void mostrarDialogAgregarCliente(BuildContext context) {
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      final style = Theme.of(context).textTheme;
      return AlertDialog(
        title: Text("Agregar Cliente", style: style.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: direccionController,
                  decoration:
                      const InputDecoration(labelText: "Dirección (opcional)"),
                ),
                TextField(
                  controller: telefonoController,
                  decoration:
                      const InputDecoration(labelText: "Teléfono (opcional)"),
                  keyboardType: TextInputType.phone,
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
                      ? null
                      : direccionController.text.trim(),
                  telefono: telefonoController.text.isEmpty
                      ? null
                      : telefonoController.text.trim(),
                );

                bool success = await enviarCliente(cliente, context);
                Navigator.pop(context, true);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: success ? Colors.green : Colors.red,
                    content: Text(success
                        ? 'Cliente agregado correctamente'
                        : 'Error al agregar cliente'),
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

Future<bool> enviarCliente(Cliente client, context) async {
  return Provider.of<ClienteProvider>(context, listen: false)
      .addCliente(client);
}
