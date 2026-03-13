import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEquipoToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onEquipoChanged;
  final Function? onDelete;
  const AddEquipoToProyecto({
    super.key,
    required this.onEquipoChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddEquipoToProyectoState();
}

class _AddEquipoToProyectoState extends State<AddEquipoToProyecto> {
  final _nombreController = TextEditingController();
  final _rolController = TextEditingController();
  final _horasController = TextEditingController();
  List<Map<String, dynamic>> equipo = [];

  void _agregarMiembro() {
    if (_nombreController.text.isEmpty ||
        _rolController.text.isEmpty ||
        _horasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos del miembro")),
      );
      return;
    }

    final miembro = {
      "nombre_miembro": _nombreController.text,
      "rol": _rolController.text,
      "horas_asignadas": int.tryParse(_horasController.text) ?? 0,
    };

    setState(() {
      equipo.add(miembro);
    });

    // Notificar al widget padre
    widget.onEquipoChanged(equipo);

    // Limpiar campos
    _nombreController.clear();
    _rolController.clear();
    _horasController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        textFieldWidgetUI(
          label: 'Nombre del miembro',
          controller: _nombreController,
        ),

        textFieldWidgetUI(label: 'Rol', controller: _rolController),

        textFieldWidgetUI(
          label: 'Horas asignadas',
          controller: _horasController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onEditingComplete: _agregarMiembro,
        ),
        SizedBox(height: 5),
        CustomLoginButton(
          onPressed: _agregarMiembro,
          text: "Agregar miembro",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text("Equipo agregado:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...equipo.map(
          (m) => ListTile(
            title: Text("${m['nombre_miembro']} - ${m['rol']}"),
            subtitle: Text("Horas: ${m['horas_asignadas']}"),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete!(equipo);
                  equipo.remove(m);
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
