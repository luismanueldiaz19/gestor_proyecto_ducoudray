import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddHorasInvertidasToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onHorasChanged;
  final Function? onDelete;

  const AddHorasInvertidasToProyecto({
    super.key,
    required this.onHorasChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddHorasInvertidasToProyectoState();
}

class _AddHorasInvertidasToProyectoState
    extends State<AddHorasInvertidasToProyecto> {
  final _miembroController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horasController = TextEditingController();
  final _costoHoraController = TextEditingController();

  List<Map<String, dynamic>> horasInvertidas = [];

  void _agregarHoras() {
    if (_miembroController.text.isEmpty ||
        _fechaController.text.isEmpty ||
        _horasController.text.isEmpty ||
        _costoHoraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Completa todos los campos de horas invertidas"),
        ),
      );
      return;
    }

    final horas = {
      "miembro": _miembroController.text,
      "fecha": _fechaController.text,
      "horas": int.tryParse(_horasController.text) ?? 0,
      "costo_hora": double.tryParse(_costoHoraController.text) ?? 0,
    };

    setState(() {
      horasInvertidas.add(horas);
    });

    widget.onHorasChanged(horasInvertidas);

    _miembroController.clear();
    _fechaController.clear();
    _horasController.clear();
    _costoHoraController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textFieldWidgetUI(label: 'Miembro', controller: _miembroController),
        textFieldWidgetUI(label: 'Fecha', controller: _fechaController),
        textFieldWidgetUI(
          label: 'Horas',
          controller: _horasController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        textFieldWidgetUI(
          label: 'Costo por hora',
          controller: _costoHoraController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        CustomLoginButton(
          onPressed: _agregarHoras,
          text: "Agregar horas",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Horas invertidas agregadas:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...horasInvertidas.map(
          (h) => ListTile(
            title: Text("${h['miembro']} - ${h['fecha']}"),
            subtitle: Text(
              "Horas: ${h['horas']} | Costo/hora: ${h['costo_hora']}",
            ),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(horasInvertidas);
                  horasInvertidas.remove(h);
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
