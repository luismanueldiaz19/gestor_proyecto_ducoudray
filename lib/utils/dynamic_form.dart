import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../palletes/app_colors.dart';

class DynamicForm extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final void Function(Map<String, dynamic>) onSave;
  final String? title;
  final Map<String, dynamic>? initialData;
  const DynamicForm({
    super.key,
    required this.fields,
    required this.onSave,
    this.title,
    this.initialData,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      final value = widget.initialData != null
          ? widget.initialData![field["name"]] ?? ""
          : "";
      _controllers[field["name"]] = TextEditingController(text: value);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
          widget.initialData == null
              ? 'Crear ${widget.title ?? 'Formulario dinámico'}'
              : 'Actualizar ${widget.title ?? 'Formulario dinámico'}',
          style: style.titleMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: widget.fields.map((field) {
              final controller = _controllers[field["name"]]!;
              final type = field["type"] ?? "text";
              // --- Nuevo: input formatters según el tipo ---
              List<TextInputFormatter>? inputFormatters;
              if (type == "number") {
                inputFormatters = [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ];
              }
              return Container(
                // width: width,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                child: TextFormField(
                  controller: controller,
                  inputFormatters: inputFormatters,
                  onChanged: (v) {
                    // Esto fuerza la reconstrucción para mostrar/ocultar el ícono
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: field["label"] ?? field["name"],
                    suffixIcon: (field["required"] ?? false) &&
                            (controller.text.isEmpty)
                        ? Tooltip(
                            message: 'Campos Obligatorio',
                            child: Icon(Icons.close, color: Colors.red))
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                          color: Color(0xFF003DA5), width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if ((field["required"] ?? false) &&
                        (v == null || v.isEmpty)) {
                      return "Campo obligatorio";
                    }
                    return null;
                  },
                  keyboardType: type == "email"
                      ? TextInputType.emailAddress
                      : type == "phone"
                          ? TextInputType.number
                          : TextInputType.text,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: Colors.red)),
        ),
        SizedBox(
          width: 200,
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.initialData == null
                  ? AppColors.primary
                  : Colors.green, // Azul oscuro como en la imagen
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 3,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final data = <String, dynamic>{};
                for (var field in widget.fields) {
                  final value = _controllers[field["name"]]!.text.trim();
                  data[field["name"]] =
                      value.isEmpty && !(field["required"] ?? false)
                          ? "N/A"
                          : value;
                }

                if (widget.initialData == null) {
                  // Registrar
                  // print("Registrar nuevo: $data");
                  widget.onSave(data); // Aquí llamas a tu API de insert
                } else {
                  // Actualizar
                  // print("Actualizar: $data");
                  widget.onSave(data); // Aquí llamas a tu API de update
                }

                Navigator.pop(context);
              }
            },
            child: Text(
              widget.initialData == null ? 'Guardar' : 'Actualizar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
