import 'package:flutter/material.dart';

import '../../model/usuario.dart';
import '../../utils/constants.dart';

class PerfilUsuarioPage extends StatelessWidget {
  final Usuario usuario;

  const PerfilUsuarioPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.sizeOf(context);
    final permisos = currentUsuario?.permisos ?? [];
    final agrupado = agruparPorModulo(permisos);
    String capitalizeFirst(String value) {
      if (value.isEmpty) return value;
      return value[0].toUpperCase() + value.substring(1).toLowerCase();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            usuario.nombreCompleto ?? 'Sin nombre',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '@${usuario.usuario ?? ''}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),

          const SizedBox(height: 16),

          // Estado
          Row(
            children: [
              const Text(
                'Estado: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(
                usuario.statusUsuario ? Icons.check_circle : Icons.cancel,
                color: usuario.statusUsuario ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                usuario.statusUsuario ? 'Activo' : 'Deshabilitado',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const Divider(height: 32),

          // Roles
          const Text(
            'Roles:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Wrap(
            spacing: 8,
            children: usuario.roles!
                .map(
                  (rol) => Chip(
                    label: Text(rol),
                    backgroundColor: Colors.deepPurple.shade200,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                )
                .toList(),
          ),

          // Vehículos asignados
          const Text(
            'Vehículos asignados:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          // Permisos
          const Text(
            'Permisos:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.9,
                  maxCrossAxisExtent: 180,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: agrupado.keys.length,
                itemBuilder: (context, index) {
                  final modulo = agrupado.keys.elementAt(index);
                  final acciones = agrupado[modulo]!;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.lock_open_rounded,
                            size: 100,
                            color: Colors.blueGrey.shade50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeFirst(modulo.toString()),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                'Acciones',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade300,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: acciones.length,
                                  itemBuilder: (context, i) {
                                    return Text(
                                      "- ${acciones[i]}",
                                      style: const TextStyle(fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<String>> agruparPorModulo(List<String> permisos) {
    final Map<String, List<String>> agrupado = {};

    for (var permiso in permisos) {
      final modulo = permiso ?? 'Sin módulo';
      // final action = permiso.action ?? 'Sin acción';

      if (!agrupado.containsKey(modulo)) {
        agrupado[modulo] = [];
      }
      // agrupado[modulo]!.add(action);
    }

    return agrupado;
  }
}
