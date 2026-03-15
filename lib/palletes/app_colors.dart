import 'package:flutter/material.dart';

class AppColors {
  static const Color surface = Color(0xFFFFFFFF); // Blanco

  // ===============================
  // 🎨 COLORES PRINCIPALES (LOGO)
  // ===============================

  /// Verde oliva (pieza superior)
  static const Color primaryOlive = Color(0xFF7A7B3A);

  /// Amarillo mostaza (pieza derecha)
  static const Color mustard = Color(0xFFCBB86A);

  /// Marrón corporativo (pieza izquierda)
  static const Color corporateBrown = Color(0xFFA0622E);

  /// Verde azulado / teal (pieza inferior)
  static const Color tealGreen = Color(0xFF3F6663);

  // ===============================
  // 🎨 COLORES SECUNDARIOS
  // ===============================

  /// Color principal de la app
  static const Color primary = primaryOlive;

  /// Color secundario
  static const Color secondary = tealGreen;

  /// Color de acento
  static const Color accent = mustard;

  // ===============================
  // 🧾 TEXTO
  // ===============================

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textLight = Colors.white;

  // ===============================
  // 🧱 FONDOS
  // ===============================

  static const Color background = Color(0xFFF4F4F4);
  static const Color cardBackground = Colors.white;

  // ===============================
  // ⚠️ ESTADOS
  // ===============================

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);
}
