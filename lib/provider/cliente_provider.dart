import 'package:flutter/material.dart';
import '../model/cliente.dart';
import '../repositories/cliente_service.dart';

class ClienteProvider extends ChangeNotifier {
  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _isLoading = false;
  String _filter = '';
  List<Cliente> get clientesOriginal => _clientes;
  List<Cliente> get clientes =>
      _clientesFiltrados.isNotEmpty ? _clientesFiltrados : _clientes;

  bool get isLoading => _isLoading;

  String get filterPicked => _filter;

  Future<void> fetchClientes() async {
    _isLoading = true;
    nombreClient = null;
    notifyListeners();
    print('obtener clientes');
    try {
      _clientes = await ClienteService.fetchClientes();
      _clientesFiltrados = [];
    } catch (e) {
      debugPrint('Error al obtener clientes: $e');
      _clientes = [];
      _clientesFiltrados = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void limpiarClientes() {
    _clientes = [];
    _clientesFiltrados = [];
    notifyListeners();
  }

  void filtrarPorNombre(String texto) {
    _filter = texto;
    if (texto.isEmpty) {
      _clientesFiltrados = [];
    } else {
      _clientesFiltrados = _clientes
          .where(
            (c) =>
                c.nombre != null &&
                c.nombre!.toLowerCase().contains(texto.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  // ✅ MÉTODO NUEVO: Agregar un cliente
  Future<bool> addCliente(Cliente cliente) async {
    final success = await ClienteService.createCliente(cliente);
    if (success) {
      await fetchClientes(); // Recarga toda la lista desde el servidor
      // notifyListeners();
    }
    return success;
  }

  String? nombreClient;

  void setFilterCliente(value) {
    nombreClient = value;
    filterPedidos();
    notifyListeners();
  }

  void filterPedidos() {
    _clientesFiltrados = _clientes.where((pedido) {
      bool matches = true;
      if (nombreClient != null && nombreClient!.isNotEmpty) {
        matches =
            matches &&
            (pedido.nombre?.toLowerCase() == nombreClient!.toLowerCase());
      }
      return matches;
    }).toList();
  }

  void clearFilters() {
    _clientesFiltrados = _clientes;
    nombreClient = null;
    notifyListeners();
  }
}
