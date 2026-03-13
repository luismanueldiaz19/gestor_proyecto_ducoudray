import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/cliente.dart';
import '../../palletes/app_colors.dart';
import '../../provider/cliente_provider.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_loading.dart';
import 'add_client.dart';

Future<Cliente?> showClientDialog(BuildContext context) {
  return showDialog<Cliente>(
    context: context,
    builder: (context) => _ClienteDialog(),
  );
}

class _ClienteDialog extends StatefulWidget {
  @override
  State<_ClienteDialog> createState() => _ClienteDialogState();
}

class _ClienteDialogState extends State<_ClienteDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ClienteProvider>(context, listen: false).fetchClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final sized = MediaQuery.sizeOf(context);
    final clienteProvider = Provider.of<ClienteProvider>(context);
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
          Text('Clientes', style: style.bodyMedium),
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
        width: 350,
        child: Column(
          children: [
            buildTextField(
              'Buscar',
              onChanged: (filter) => clienteProvider.filtrarPorNombre(filter),
            ),
            clienteProvider.isLoading
                ? const Expanded(child: CustomLoading())
                : clienteProvider.clientes.isEmpty
                ? const Text('No hay clientes disponibles.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: clienteProvider.clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clienteProvider.clientes[index];
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 350,
                            minWidth: 150,
                          ),
                          child: Card(
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
                                      radius: 21,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cliente.nombre ??
                                                'Nombre no disponible',
                                            style: style.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                cliente.telefono ??
                                                    'Sin teléfono',
                                                style: style.bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  cliente.direccion ??
                                                      'Sin dirección',
                                                  style: style.bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey[700],
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

class CardCliente extends StatelessWidget {
  const CardCliente({super.key, this.cliente});
  final Cliente? cliente;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(color: AppColors.primary.withOpacity(0.15)),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        // onTap: () => Navigator.of(context).pop(cliente),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 21,
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente!.nombre ?? 'Nombre no disponible',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          cliente?.telefono ?? 'Sin teléfono',
                          style: style.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cliente?.direccion ?? 'Sin dirección',
                            style: style.bodySmall?.copyWith(
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
              // const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
