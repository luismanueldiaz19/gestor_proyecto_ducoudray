import 'package:flutter/material.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddPropuestaToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onPropuestaChanged;
  final Function? onDelete;

  const AddPropuestaToProyecto({
    super.key,
    required this.onPropuestaChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddPropuestaToProyectoState();
}

class _AddPropuestaToProyectoState extends State<AddPropuestaToProyecto> {
  final _descripcionController = TextEditingController();
  final _estadoController = TextEditingController();
  final _pathFileController = TextEditingController(text: 'N/A');

  List<Map<String, dynamic>> propuestas = [];

  void _agregarPropuesta() {
    if (_descripcionController.text.isEmpty || _estadoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos de la propuesta")),
      );
      return;
    }

    final propuesta = {
      "descripcion": _descripcionController.text,
      "estado": _estadoController.text,
      "path_file": _pathFileController.text.isEmpty
          ? "N/A"
          : _pathFileController.text,
    };

    setState(() {
      propuestas.add(propuesta);
    });

    widget.onPropuestaChanged(propuestas);

    _descripcionController.clear();
    _estadoController.clear();
    _pathFileController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        textFieldWidgetUI(
          label: 'Descripción',
          controller: _descripcionController,
        ),
        textFieldWidgetUI(label: 'Estado', controller: _estadoController),
        textFieldWidgetUI(
          label: 'Ruta archivo (opcional)',
          controller: _pathFileController,
        ),
        SizedBox(height: 5),
        CustomLoginButton(
          onPressed: _agregarPropuesta,
          text: "Agregar propuesta",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Propuestas agregadas:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...propuestas.map(
          (p) => ListTile(
            title: Text("${p['descripcion']} - ${p['estado']}"),
            subtitle: Text("Archivo: ${p['path_file']}"),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(propuestas);
                  propuestas.remove(p);
                });
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ],
    );
  }
}
