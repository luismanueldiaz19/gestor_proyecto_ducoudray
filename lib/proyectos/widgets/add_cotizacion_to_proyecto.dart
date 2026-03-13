import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/utils/helpers.dart';

class AddCotizacionToProyecto extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCotizacionChanged;
  final Function? onDelete;

  const AddCotizacionToProyecto({
    super.key,
    required this.onCotizacionChanged,
    this.onDelete,
  });

  @override
  State createState() => _AddCotizacionToProyectoState();
}

class _AddCotizacionToProyectoState extends State<AddCotizacionToProyecto> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _estadoController = TextEditingController();
  final _fechaController = TextEditingController();

  List<Map<String, dynamic>> cotizaciones = [];

  void _agregarCotizacion() {
    if (_descripcionController.text.isEmpty ||
        _montoController.text.isEmpty ||
        _estadoController.text.isEmpty ||
        _fechaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Completa todos los campos de la cotización"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cotizacion = {
      "descripcion": _descripcionController.text,
      "monto": double.tryParse(_montoController.text) ?? 0,
      "estado": _estadoController.text,
      "fecha": _fechaController.text,
    };

    setState(() {
      cotizaciones.add(cotizacion);
    });

    // Notificar al widget padre
    widget.onCotizacionChanged(cotizaciones);

    // Limpiar campos
    _descripcionController.clear();
    _montoController.clear();
    _estadoController.clear();
    _fechaController.clear();
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
          label: 'Monto',
          controller: _montoController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        textFieldWidgetUI(label: 'Estado', controller: _estadoController),
        textFieldWidgetUI(
          label: 'Fecha',
          controller: _fechaController,
          keyboardType: TextInputType.datetime,
        ),
        SizedBox(height: 5),
        CustomLoginButton(
          onPressed: _agregarCotizacion,
          text: "Agregar cotización",
          colorButton: AppColors.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Cotizaciones agregadas:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...cotizaciones.map(
          (c) => ListTile(
            title: Text("${c['descripcion']} - ${c['estado']}"),
            subtitle: Text("Monto: ${c['monto']} | Fecha: ${c['fecha']}"),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  widget.onDelete?.call(cotizaciones);
                  cotizaciones.remove(c);
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
