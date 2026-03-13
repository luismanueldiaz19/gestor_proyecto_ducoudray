import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';

import '../../model/usuario.dart';
import '../../palletes/app_colors.dart';

import '../../repositories/usuarios_services.dart';
import '../../widgets/custom_loading.dart';
import 'add_client.dart';

Future<Usuario?> showDriverDialog(BuildContext context) {
  return showDialog<Usuario>(
    context: context,
    builder: (context) => _DriverDialog(),
  );
}

class _DriverDialog extends StatefulWidget {
  @override
  State<_DriverDialog> createState() => _DriverDialogState();
}

class _DriverDialogState extends State<_DriverDialog> {
  final UsuariosServices _api = UsuariosServices();

  List<Usuario> listFilter = [];
  List<Usuario> list = [];

  @override
  void initState() {
    super.initState();
    getDriver();
  }

  Future getDriver() async {
    list = await _api.getAllDriver();
    setState(() {
      listFilter = list;
    });
  }

  void filtrarPorNombre(String texto) {
    if (texto.isEmpty) {
      listFilter = [];
    } else {
      listFilter = list
          .where(
            (c) =>
                c.nombreCompleto != null &&
                c.usuario!.toLowerCase().contains(texto.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.sizeOf(context);
    // final clienteProvider = Provider.of<ClienteProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Chofer', style: style.bodyMedium),
          IconButton(
            onPressed: () {
              mostrarDialogAgregarCliente(context);
            },
            icon: Icon(Icons.group_add_sharp),
          ),
        ],
      ),
      content: SizedBox(
        height: sized.height * 0.60,
        width: sized.width * 0.50,
        child: Column(
          children: [
            buildTextField(
              'Buscar',
              onChanged: (filter) => filtrarPorNombre(filter),
            ),
            listFilter.isEmpty
                ? const Expanded(child: CustomLoading())
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listFilter.length,
                      itemBuilder: (context, index) {
                        final cliente = listFilter[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: AppColors.primary.withOpacity(0.15),
                            ),
                          ),
                          elevation: 4,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(context).pop(cliente),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    radius: 24,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cliente.nombreCompleto ??
                                              'Nombre no disponible',
                                          style: style.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.qr_code_2_outlined,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                cliente.usuario ?? 'Usuario',
                                                style: style.bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
