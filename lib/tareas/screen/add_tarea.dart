import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/usuario.dart';
import '../../palletes/app_colors.dart';
import '../../repositories/usuarios_services.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/buscador_dialog.dart';
import '../provider_tareas/tarea_provider.dart';

class AddTarea extends StatefulWidget {
  const AddTarea({super.key});

  @override
  State createState() => _AddTareaState();
}

//se actualizo el sistema correctamente. se agrego todo sin problema algunos
class _AddTareaState extends State<AddTarea> {
  final TextEditingController _contTitulo = TextEditingController();
  final TextEditingController _contAsignar = TextEditingController();
  final TextEditingController _contDestalles = TextEditingController();
  String dateCreated = DateTime.now().toString().substring(0, 19);
  void addTask() async {
    if (_contDestalles.text.isNotEmpty && _contTitulo.text.isNotEmpty) {
      final payload = {
        "titulo": _contTitulo.text.toUpperCase().trim(),
        "descripcion": _contDestalles.text.trim(),
        "usuario": _contAsignar.text.isEmpty
            ? currentUsuario?.nombreCompleto?.toUpperCase()
            : _contAsignar.text.trim().toUpperCase(),
        "creado_en": dateCreated,
        'registed_by': currentUsuario?.nombreCompleto?.toUpperCase(),
      };
      print(payload);
      bool? value = await Provider.of<TareaProvider>(
        context,
        listen: false,
      ).agregarTareaMain(context, payload);
      if (value != null && true) {
        if (!mounted) return;
        cleanAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrado correctamente'),
            duration: Durations.short2,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar en el servidor'),
            duration: Durations.medium1,
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe de llenar todo los campos'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  cleanAll() {
    setState(() {
      _contTitulo.clear();
      _contDestalles.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _contTitulo.dispose();
    _contDestalles.dispose();
  }

  @override
  void initState() {
    super.initState();
    getAllUsuario();
  }

  List<Usuario> _list = [];

  Future getAllUsuario() async {
    try {
      _list = await UsuariosServices().getAllUsuarios();
      setState(() {});
    } catch (e) {
      // throw Exception("Error al cargar roles");
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar nueva tarea')),
      body: Column(
        children: [
          const SizedBox(width: double.infinity, height: 10),
          if (_list.isNotEmpty)
            textFieldWidgetUI(
              controller: _contAsignar,
              label: 'Cambiar el usuario para la tarea ?',
              hintText: 'Puede asignar !',
              readOnly: true,
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BuscadorDialog(
                      items: Usuario.getUniqueNombreCompleto(_list),
                      onSelected: (value) {
                        _contAsignar.text = value;
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          if (_contAsignar.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 5,
                children: [
                  Text('Ha seleccionado a', style: style.titleMedium),
                  Text(_contAsignar.text.toUpperCase(), style: style.bodyLarge),
                  CustomTextIconButton(
                    onPressed: () {
                      setState(() {
                        _contAsignar.clear();
                      });
                    },
                    icon: Icons.remove,
                    text: 'Quitar Asignación',
                    colorButton: Colors.transparent,
                    textColor: AppColors.error,
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () async {
              await pickSingleDate(context, (fecha) {
                setState(() {
                  dateCreated = fecha.substring(0, 19);
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              height: 50,
              width: 250,
              alignment: Alignment.center,
              child: Text('Fecha : ${dateCreated.toString().substring(0, 10)}'),
            ),
          ),
          textFieldWidgetUI(
            controller: _contTitulo,
            label: 'Escribir titulo',
            hintText: 'limite 20 Caracter',
            maxLength: 20,
          ),
          textFieldWidgetUI(
            label: 'Detalles',
            controller: _contDestalles,
            hintText: 'Detalles de la tarea',
          ),
          CustomLoginButton(
            onPressed: addTask,
            text: "Crear Tarea",
            colorButton: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
