import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddGastoToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onGastoChanged;
  final Function? onDelete;

  const AddGastoToProyecto({
    super.key,
    required this.onGastoChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddGastoToProyectoState();
}

class _AddGastoToProyectoState extends State<AddGastoToProyecto> {
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  final _tipoController = TextEditingController();
  final _fechaController = TextEditingController();

  List<Map<String, dynamic>> gastos = [];

  void _agregarGasto() {
    if (_conceptoController.text.isEmpty ||
        _montoController.text.isEmpty ||
        _tipoController.text.isEmpty ||
        _fechaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos del gasto")),
      );
      return;
    }

    final gasto = {
      "concepto": _conceptoController.text,
      "monto": double.tryParse(_montoController.text) ?? 0,
      "tipo": _tipoController.text,
      "fecha": _fechaController.text,
    };

    setState(() {
      gastos.add(gasto);
    });

    // Notificar al widget padre
    widget.onGastoChanged(gastos);

    // Limpiar campos
    _conceptoController.clear();
    _montoController.clear();
    _tipoController.clear();
    _fechaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: double.infinity),
        textFieldWidgetUI(label: 'Concepto', controller: _conceptoController),
        textFieldWidgetUI(
          label: 'Monto',
          controller: _montoController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        textFieldWidgetUI(label: 'Tipo', controller: _tipoController),
        textFieldWidgetUI(
          label: 'Fecha',
          controller: _fechaController,
          onTap: () async {
            await pickSingleDate(context, (fecha) {
              setState(() {
                _fechaController.text = fecha.toString().substring(0, 10);
              });
            });
          },
          readOnly: true,
          suffixIcon: Icons.calendar_month_outlined,
        ),

        SizedBox(height: 5),
        CustomLoginButton(
          onPressed: _agregarGasto,
          text: "Agregar gasto",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Gastos agregados:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...gastos.map(
          (g) => ListTile(
            title: Text("${g['concepto']} - ${g['tipo']}"),
            subtitle: Text("Monto: ${g['monto']} | Fecha: ${g['fecha']}"),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(gastos);
                  gastos.remove(g);
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
