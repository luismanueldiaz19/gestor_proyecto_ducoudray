import 'package:ducoudray/proyectos/model/proyecto.dart';
import 'package:flutter/material.dart';

import '../repositories/repositorie_proyecto.dart';

class ProviderProyecto extends ChangeNotifier {
  List<Proyecto> _proyecto = [];
  List<Proyecto> _proyectoFiltrados = [];
  List<Proyecto> get proyectoOriginal => _proyecto;
  List<Proyecto> get proyecto =>
      _proyectoFiltrados.isNotEmpty ? _proyectoFiltrados : _proyecto;
  Future<void> getproyectos() async {
    debugPrint('obtener get proyectos ......');
    try {
      _proyecto = await RepositorieProyecto.fetchProyectos();
      _proyectoFiltrados = [];
    } catch (e) {
      debugPrint('Error al obtener clientes: $e');
      _proyecto = [];
      _proyectoFiltrados = [];
    }

    notifyListeners();
  }
}
