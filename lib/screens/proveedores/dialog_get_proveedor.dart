import 'package:flutter/material.dart';
import '../../model/proveedor.dart';

import '../../palletes/app_colors.dart';
import '../../repositories/proveedor_repositories.dart';
import '../../widgets/card_proveedor.dart';

Future<Proveedor?> mostrarDialogoSeleccionProveedor(
  BuildContext context,
) async {
  return showDialog<Proveedor>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      // insetAnimationCurve: Curves.bounceInOut,
      // insetAnimationDuration: const Duration(seconds: 2),
      child: _DialogCatalogoSelector(),
    ),
  );
}

class _DialogCatalogoSelector extends StatefulWidget {
  @override
  State<_DialogCatalogoSelector> createState() =>
      _DialogCatalogoSelectorState();
}

class _DialogCatalogoSelectorState extends State<_DialogCatalogoSelector> {
  List<Proveedor> list = [];
  List<Proveedor> filteredList = [];
  String searchQuery = "";
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    getCatalogo();
  }

  Future<void> getCatalogo() async {
    List<Proveedor> response = await ProveedorRepositories.fetchProveedor();
    if (response.isNotEmpty) {
      list = response;
      filteredList = list;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = list
        .map((c) => c.tipoProveedor ?? "")
        .toSet()
        .where((c) => c.isNotEmpty)
        .toList();

    final style = Theme.of(context).textTheme;

    final productosFiltrados = list.where((c) {
      final matchSearch =
          c.nombreProveedor?.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ??
          false;
      final matchCategory =
          selectedCategory == null || c.tipoProveedor == selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    return SizedBox(
      width: 400,
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Buscar producto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              isExpanded: false,
              hint: const Text("Filtrar por categoría"),
              items: [
                const DropdownMenuItem(value: null, child: Text("Todas")),
                ...categorias.map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        cat,
                        overflow: TextOverflow.ellipsis,
                        style: style.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: productosFiltrados.isEmpty
                ? const Center(child: Text("No hay proveedor disponibles"))
                : ListView.builder(
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final item = productosFiltrados[index];
                      return CardProveedor(item: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
