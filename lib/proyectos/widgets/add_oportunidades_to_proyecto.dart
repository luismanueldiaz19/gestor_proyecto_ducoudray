import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddOportunidadToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onOportunidadChanged;
  final Function? onDelete;

  const AddOportunidadToProyecto({
    super.key,
    required this.onOportunidadChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddOportunidadToProyectoState();
}

class _AddOportunidadToProyectoState extends State<AddOportunidadToProyecto> {
  final _descripcionController = TextEditingController();
  final _fechaController = TextEditingController();
  final _probabilidadController = TextEditingController();
  final _valorEstimadoController = TextEditingController();

  List<Map<String, dynamic>> oportunidades = [];

  void _agregarOportunidad() {
    if (_descripcionController.text.isEmpty ||
        _fechaController.text.isEmpty ||
        _probabilidadController.text.isEmpty ||
        _valorEstimadoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos de la oportunidad")),
      );
      return;
    }

    final oportunidad = {
      "descripcion": _descripcionController.text,
      "fecha": _fechaController.text,
      "probabilidad": int.tryParse(_probabilidadController.text) ?? 0,
      "valor_estimado": double.tryParse(_valorEstimadoController.text) ?? 0,
    };

    setState(() {
      oportunidades.add(oportunidad);
    });

    widget.onOportunidadChanged(oportunidades);

    _descripcionController.clear();
    _fechaController.clear();
    _probabilidadController.clear();
    _valorEstimadoController.clear();
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
        textFieldWidgetUI(
          label: 'Fecha',
          controller: _fechaController,
          keyboardType: TextInputType.datetime,
        ),
        textFieldWidgetUI(
          label: 'Probabilidad (%)',
          controller: _probabilidadController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        textFieldWidgetUI(
          label: 'Valor estimado',
          controller: _valorEstimadoController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        SizedBox(height: 5),
        CustomLoginButton(
          onPressed: _agregarOportunidad,
          text: "Agregar oportunidad",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Oportunidades agregadas:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...oportunidades.map(
          (o) => ListTile(
            title: Text("${o['descripcion']} - ${o['fecha']}"),
            subtitle: Text(
              "Probabilidad: ${o['probabilidad']}% | Valor: ${o['valor_estimado']}",
            ),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(oportunidades);
                  oportunidades.remove(o);
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
