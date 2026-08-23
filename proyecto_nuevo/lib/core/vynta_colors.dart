import 'package:flutter/material.dart';

/// Paleta de colores de Vynta.
/// Fuente: docs/Informe_de_arquitectura.pdf — guía de estilo.
class VyntaColors {
  const VyntaColors._();

  /// Morado principal (#7A39FA) — color de marca (brand).
  /// Fondos de bienvenida, pantallas de carga y branding.
  static const Color brandPurple = Color(0xFF7A39FA);

  /// Turquesa/Menta (#22D3EE) — color de acción (accent).
  /// Botones principales, elementos activos del menú inferior y headers de perfil.
  static const Color accentTurquoise = Color(0xFF22D3EE);

  /// Teal oscuro (#1A8797) — color de navegación.
  /// Barras de búsqueda superiores y headers secundarios.
  static const Color navTeal = Color(0xFF1A8797);

  /// Gris claro (#F3F4F6) — fondo de contenido.
  /// Fondos de tarjetas de categorías y cuerpo de la app.
  static const Color contentGrey = Color(0xFFF3F4F6);

  /// Blanco (#FFFFFF) — color de tarjetas e inputs.
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// Negro / gris oscuro (#222222) — texto e íconos.
  static const Color ink = Color(0xFF222222);

  /// Radio de curvatura homogéneo (8–12px) según guía de estilo.
  static const double radius = 12;
  static const double radiusSmall = 8;

  /// Margen interno mínimo recomendado en botones e inputs (14px).
  static const double internalPadding = 14;
}

/// Fondo unificado para pantallas de la app (gris claro de contenido).
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
