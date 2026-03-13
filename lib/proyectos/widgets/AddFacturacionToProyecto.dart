import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddFacturacionToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onFacturacionChanged;
  final Function? onDelete;

  const AddFacturacionToProyecto({
    super.key,
    required this.onFacturacionChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddFacturacionToProyectoState();
}

class _AddFacturacionToProyectoState extends State<AddFacturacionToProyecto> {
  final _montoController = TextEditingController();
  final _estadoController = TextEditingController();
  final _fechaController = TextEditingController();

  List<Map<String, dynamic>> facturacion = [];

  void _agregarFactura() {
    if (_montoController.text.isEmpty ||
        _estadoController.text.isEmpty ||
        _fechaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos de facturación")),
      );
      return;
    }

    final factura = {
      "monto": double.tryParse(_montoController.text) ?? 0,
      "estado": _estadoController.text,
      "fecha": _fechaController.text,
    };

    setState(() {
      facturacion.add(factura);
    });

    widget.onFacturacionChanged(facturacion);

    _montoController.clear();
    _estadoController.clear();
    _fechaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textFieldWidgetUI(
          label: 'Monto',
          controller: _montoController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        textFieldWidgetUI(label: 'Estado', controller: _estadoController),
        textFieldWidgetUI(label: 'Fecha', controller: _fechaController),
        CustomLoginButton(
          onPressed: _agregarFactura,
          text: "Agregar facturación",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Facturación agregada:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...facturacion.map(
          (f) => ListTile(
            title: Text("Monto: ${f['monto']} - Estado: ${f['estado']}"),
            subtitle: Text("Fecha: ${f['fecha']}"),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(facturacion);
                  facturacion.remove(f);
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
