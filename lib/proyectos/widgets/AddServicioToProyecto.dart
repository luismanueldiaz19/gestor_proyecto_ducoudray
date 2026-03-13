import 'package:flutter/material.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddServicioToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onServicioChanged;
  final Function? onDelete;

  const AddServicioToProyecto({
    super.key,
    required this.onServicioChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddServicioToProyectoState();
}

class _AddServicioToProyectoState extends State<AddServicioToProyecto> {
  final _nombreServicioController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  final _estadoController = TextEditingController();

  List<Map<String, dynamic>> servicios = [];

  void _agregarServicio() {
    if (_nombreServicioController.text.isEmpty ||
        _fechaInicioController.text.isEmpty ||
        _fechaFinController.text.isEmpty ||
        _estadoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos del servicio")),
      );
      return;
    }

    final servicio = {
      "nombre_servicio": _nombreServicioController.text,
      "fecha_inicio": _fechaInicioController.text,
      "fecha_fin": _fechaFinController.text,
      "estado": _estadoController.text,
    };

    setState(() {
      servicios.add(servicio);
    });

    widget.onServicioChanged(servicios);

    _nombreServicioController.clear();
    _fechaInicioController.clear();
    _fechaFinController.clear();
    _estadoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textFieldWidgetUI(
          label: 'Nombre del servicio',
          controller: _nombreServicioController,
        ),
        textFieldWidgetUI(
          label: 'Fecha inicio',
          controller: _fechaInicioController,
        ),
        textFieldWidgetUI(label: 'Fecha fin', controller: _fechaFinController),
        textFieldWidgetUI(label: 'Estado', controller: _estadoController),
        CustomLoginButton(
          onPressed: _agregarServicio,
          text: "Agregar servicio",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Servicios agregados:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...servicios.map(
          (s) => ListTile(
            title: Text("${s['nombre_servicio']} - ${s['estado']}"),
            subtitle: Text(
              "Inicio: ${s['fecha_inicio']} | Fin: ${s['fecha_fin']}",
            ),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(servicios);
                  servicios.remove(s);
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
