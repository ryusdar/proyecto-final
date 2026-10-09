import 'package:flutter/material.dart';

/// Paleta de colores de Vynta.

class VyntaColors {
  const VyntaColors._();

  /// Fondos de bienvenida, pantallas de carga y branding.
  static const Color brandPurple = Color(0xFF7A39FA);

  /// Botones principales, elementos activos del menú inferior y headers de perfil.
  static const Color accentTurquoise = Color(0xFF22D3EE);

  /// Barras de búsqueda superiores y headers secundarios.
  static const Color navTeal = Color(0xFF1A8797);

  /// Fondos de tarjetas de categorías y cuerpo de la app.
  static const Color contentGrey = Color(0xFFF3F4F6);

  /// Blanco (#FFFFFF) — color de tarjetas e inputs.
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// texto e íconos.
  static const Color ink = Color(0xFF222222);

  /// Radio de curvatura guía de estilo.
  static const double radius = 12;
  static const double radiusSmall = 8;

  /// Margen interno de botones
  static const double internalPadding = 14;
}

/// Fondo para pantallas de la app.
class VyntaBackground extends StatelessWidget {
  const VyntaBackground({super.key, required this.child, this.purple = false});

  final Widget child;
  final bool purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple
          ? VyntaColors.brandPurple
          : VyntaColors.contentGrey,
      body: Center(
        child: Container(
          width: 390,
          color: purple ? VyntaColors.brandPurple : VyntaColors.contentGrey,
          child: child,
        ),
      ),
    );
  }
}
