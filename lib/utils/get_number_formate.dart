import 'package:intl/intl.dart';

String getNumFormatedDouble(String numero) {
  // Convertir la cadena a double con manejo de errores
  double? number = double.tryParse(numero);

  // Validar si el número es nulo o no válido
  if (number == null) {
    return "0.00";
  }

  // Formatear el número con 2 decimales
  final formatter = NumberFormat("#,##0", "en_US");

  return formatter.format(number);
}
