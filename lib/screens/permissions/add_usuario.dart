import 'package:ducoudray/repositories/usuarios_services.dart';
import 'package:flutter/material.dart';

import '../../palletes/app_colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/validar_screen_available.dart';

class AddUsuario extends StatefulWidget {
  const AddUsuario({super.key});

  @override
  State createState() => _AddUsuarioState();
}

class _AddUsuarioState extends State<AddUsuario> {
  final _formKey = GlobalKey<FormState>();

  UsuariosServices usuariosServices = UsuariosServices();

  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController nombreCompletoController =
      TextEditingController();
  final TextEditingController occupacionController = TextEditingController();

  bool statusActivo = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedEstado = 'DRIVER';
  }

  Future<void> _guardarUsuario() async {
    if (!_formKey.currentState!.validate() || _selectedEstado == null) return;
    occupacionController.text = _selectedEstado!;
    final data = {
      "usuario": usuarioController.text.trim(),
      "contrasena": contrasenaController.text.trim(),
      "nombre_completo": nombreCompletoController.text.trim(),
      "status": statusActivo,
      "occupacion": occupacionController.text.toUpperCase().trim(),
    };

    print(data);

    setState(() => isLoading = true);

    try {
      bool? value = await usuariosServices.crearUsuarioNuevo(data);

      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado correctamente')),
        );
        Navigator.pop(context); // volver atrás
      } else {
        throw Exception('Error desconocido');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String? _selectedEstado;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    Widget mobile = Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              width: 250,
              child: buildStyledDropdown(
                label: "Seleccionar Ocupacción",
                value: _selectedEstado,
                items: ['DRIVER', 'SELLER', 'CASHIER', 'ADMIN'],
                onChanged: (val) => setState(() => _selectedEstado = val),
                style: style,
                color: AppColors.textPrimary,
                icon: Icons.directions_car,
              ),
            ),
            buildTextFieldValidator(
                label: 'Usuario',
                controller: usuarioController,
                hintText: 'Ingrese un usuario'),
            buildTextFieldValidator(
              label: 'Contraseña',
              controller: contrasenaController,
              hintText: 'Ingrese una contraseña',
            ),
            buildTextField('Nombre completo',
                controller: nombreCompletoController,
                hintText: 'Ingrese el nombre completo'),
            SwitchListTile(
              value: statusActivo,
              onChanged: (value) => setState(() => statusActivo = value),
              title: Text('¿Usuario activo?', style: style.bodyMedium),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : customButton(
                    onPressed: _guardarUsuario,
                    textButton: 'Guardar Usuario',
                    colors: AppColors.primary,
                  ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Usuario')),
      body: ValidarScreenAvailable(
        mobile: mobile,
        windows: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: mobile,
                      )),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomLoading(text: '', scale: 10),
                        Text('- Ventas de todo tipo de materiales',
                            style: const TextStyle(color: Colors.black45)),
                        Text('- Ferreteros y almacén',
                            style: const TextStyle(color: Colors.black45)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            identy(context)
          ],
        ),
      ),
    );
  }
}
