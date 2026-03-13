import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/validar_screen_available.dart';

import '../../model/proveedor.dart';
import '../../palletes/app_colors.dart';
import '../../repositories/proveedor_repositories.dart';
import '../../utils/helpers.dart';

class AddProveedores extends StatefulWidget {
  const AddProveedores({super.key, this.proveedor});
  final Proveedor? proveedor;

  @override
  State createState() => _AddProveedoresState();
}

class _AddProveedoresState extends State<AddProveedores> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final nombreController = TextEditingController();
  final rncController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final direccionController = TextEditingController();

  String? tipoProveedorSeleccionado;

  final tiposProveedor = [
    'Distribuidor',
    'Fabricante',
    'Servicios',
    'Importador',
    'Otro',
    'N/A',
  ];

  @override
  void initState() {
    super.initState();

    final proveedor = widget.proveedor;
    if (proveedor != null) {
      nombreController.text = proveedor.nombreProveedor ?? '';
      rncController.text = proveedor.rnc ?? '';
      telefonoController.text = proveedor.telefono ?? '';
      correoController.text = proveedor.correo ?? '';
      direccionController.text = proveedor.direccion ?? '';
      tipoProveedorSeleccionado = proveedor.tipoProveedor;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    double fontSizeSubtitle = 12.0;
    final formulario = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: fontSizeSubtitle),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: "Nombre del proveedor",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Campo obligatorio" : null,
            ),
            SizedBox(height: fontSizeSubtitle),
            SizedBox(
              width: 250,
              child: buildStyledDropdown(
                label: "Tipo de proveedor",
                value: tipoProveedorSeleccionado,
                items: tiposProveedor,
                onChanged: (val) =>
                    setState(() => tipoProveedorSeleccionado = val),
                style: style,
                color: AppColors.textPrimary,
                icon: Icons.work_history_outlined,
              ),
            ),
            SizedBox(height: fontSizeSubtitle),
            TextFormField(
              controller: rncController,
              decoration: InputDecoration(
                labelText: "RNC (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: fontSizeSubtitle),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(
                labelText: "Teléfono (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: fontSizeSubtitle),
            TextFormField(
              controller: correoController,
              decoration: InputDecoration(
                labelText: "Correo (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: fontSizeSubtitle),
            TextFormField(
              controller: direccionController,
              decoration: InputDecoration(
                labelText: "Dirección (opcional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: fontSizeSubtitle),
            CustomLoginButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final proveedor = {
                    "id_proveedor": widget.proveedor?.idProveedor,
                    "nombre_proveedor": nombreController.text,
                    "rnc": rncController.text,
                    "telefono": telefonoController.text.isEmpty
                        ? 'N/A'
                        : telefonoController.text,
                    "correo": correoController.text.isEmpty
                        ? 'N/A'
                        : correoController.text,
                    "direccion": direccionController.text.isEmpty
                        ? 'N/A'
                        : direccionController.text,
                    "tipo_proveedor": tipoProveedorSeleccionado ?? 'N/A',
                    "registrado_por": currentUsuario!.nombreCompleto!,
                    'actualizado_por': currentUsuario?.nombreCompleto
                        ?.toUpperCase(),
                  };

                  print("Proveedor JSON: $proveedor");

                  bool success;
                  if (widget.proveedor == null) {
                    // Crear
                    success = await ProveedorRepositories.createProveedor(
                      proveedor,
                    );
                  } else {
                    // Actualizar
                    success = await ProveedorRepositories.actualizarProveedor(
                      proveedor,
                    );
                  }

                  print(success);

                  if (success) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al guardar/Nombre ya existe!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              text: widget.proveedor == null ? 'Guardar' : 'Actualizar',
              width: 250,
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Proveedor")),
      body: ValidarScreenAvailable(
        windows: Center(child: SizedBox(width: 350, child: formulario)),
        mobile: Center(child: SizedBox(width: 450, child: formulario)),
      ),
    );
  }
}
