import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../model/tarea_pendientes.dart';
import '../repositories/tarea_repositories.dart';

class TareaProvider extends ChangeNotifier {
  List<TareaPendiente> _tareaPendiente = [];
  List<TareaPendiente> _tareaPendienteFiltro = [];
  List<TareaPendiente> get listadoPendiente => _tareaPendiente;
  List<TareaPendiente> get listadoPendienteFiltros => _tareaPendienteFiltro;
  String? tituloPicked;
  String? usuarioPicked;
  String? fechaPicked;
  String? usuarioServer;

  setUsuarioServer(String value) {
    usuarioServer = value;
    notifyListeners();
  }

  cleanUsuarioServer() {
    usuarioServer = null;
    notifyListeners();
  }

  Future<void> fetchTareas() async {
    try {
      _tareaPendiente = await TareaRepositories.getTareaCurrent(
        usuario: usuarioServer,
      );
      _tareaPendienteFiltro = _tareaPendiente;
    } catch (e) {
      debugPrint('Error al obtener reportes: $e');
      _tareaPendienteFiltro = [];
      _tareaPendiente = [];
    }
    notifyListeners();
  }

  void setFilterTitulo(String value) {
    tituloPicked = value;
    filterTarea();
    notifyListeners();
  }

  void setFilterUsuario(String value) {
    usuarioPicked = value;
    filterTarea();
    notifyListeners();
  }

  void setFilterFecha(String fecha) {
    fechaPicked = fecha;
    filterTarea();
    notifyListeners();
  }

  void cleanAll() {
    tituloPicked = null;
    usuarioPicked = null;
    fechaPicked = null;
    _tareaPendienteFiltro = _tareaPendiente;
    notifyListeners();
  }

  Future<void> removeTarea(context, id) async {
    bool? ask = await showConfirmationDialogOnyAsk(context, eliminarMjs);

    if (ask != null && ask == true) {
      try {
        bool? value = await TareaRepositories.elimninarTarea({"tarea_id": id});
        if (value == true) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }

  Future<void> actualizarTarea(context, payload) async {
    bool? ask = await showConfirmationDialogOnyAsk(context, textConfirmacion);
    if (ask != null && ask == true) {
      try {
        bool? value = await TareaRepositories.actualizarTask(payload);
        if (value == true) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }

  Future<void> removeTiempo(context, id) async {
    bool? ask = await showConfirmationDialogOnyAsk(context, eliminarMjs);

    if (ask != null && ask == true) {
      try {
        bool? value = await TareaRepositories.elimninarTiempo({
          "tiempo_id": id,
        });
        if (value == true) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }

  Future<void> iniciarTiempo(context, id) async {
    bool? ask = await showConfirmationDialogOnyAsk(
      context,
      "Esta seguro de iniciar",
    );

    if (ask != null && ask == true) {
      try {
        final value = await TareaRepositories.agregarTiempo({"tarea_id": id});
        if (value['success']) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }

  Future<void> terminarTiempo(context, id) async {
    bool? ask = await showConfirmationDialogOnyAsk(
      context,
      "Esta seguro de cerrar el tiempo",
    );

    if (ask != null && ask == true) {
      try {
        final value = await TareaRepositories.teminarTiempo({"tarea_id": id});
        if (value['success']) {
          fetchTareas();
        }
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
      }
    }
  }

  Future<bool?> agregarTareaMain(context, payload) async {
    bool? ask = await showConfirmationDialogOnyAsk(
      context,
      "Esta seguro de agregar..",
    );
    if (ask != null && ask == true) {
      try {
        final value = await TareaRepositories.agregarTask(payload);
        if (value['success']) {
          fetchTareas();
        }
        return true;
      } catch (e) {
        debugPrint('Error al obtener reportes: $e');
        return false;
      }
    }
    return false;
  }

  void filterTarea() {
    _tareaPendienteFiltro = _tareaPendiente.where((pedido) {
      bool matches = true;

      if (fechaPicked != null && fechaPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.creadoEn?.toString().substring(0, 10).toLowerCase() ==
                fechaPicked!.toLowerCase());
      }
      if (tituloPicked != null && tituloPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.titulo?.toLowerCase() == tituloPicked!.toLowerCase());
      }

      if (usuarioPicked != null && usuarioPicked!.isNotEmpty) {
        matches =
            matches &&
            (pedido.hechoPor?.toLowerCase() == usuarioPicked!.toLowerCase());
      }

      return matches;
    }).toList();
    // print('Tamano de la lista Pedido currentes : ${_pedidosFiltrados.length}');
  }
}
