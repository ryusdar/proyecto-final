import 'package:flutter/material.dart';
import 'vynta_colors.dart';
import 'accessibility_controller.dart';

class AccessibilityColors {
  // Fondo principal de las pantallas
  static Color background(BuildContext context) {
    final isDarkMode = AccessibilityScope.of(context).isDarkMode;

    return isDarkMode ? const Color(0xFF121212) : VyntaColors.contentGrey;
  }

  // Texto que se encuentra directamente sobre el fondo
  static Color text(BuildContext context) {
    final isDarkMode = AccessibilityScope.of(context).isDarkMode;

    return isDarkMode ? Colors.white : Colors.black;
  }

  // Texto secundario sobre el fondo
  static Color secondaryText(BuildContext context) {
    final isDarkMode = AccessibilityScope.of(context).isDarkMode;

    return isDarkMode ? Colors.white70 : Colors.black54;
  }
}
