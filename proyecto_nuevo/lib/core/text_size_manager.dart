import 'package:flutter/material.dart';

class TextSizeManager {
  // Tamaños para los textos.
  static const double small = 0.85;
  static const double normal = 1.0;
  static const double large = 1.20;

  // las Opciones para el texto.
  static const List<double> sizes = [small, normal, large];

  static String getSizeName(double value) {
    if (value == small) {
      return 'Pequeño';
    }

    if (value == large) {
      return 'Grande';
    }

    return 'Normal';
  }

  // se adaptan las preferencias a las nuevas opciones del tamaño de la accesibilidad.
  static double normalize(double value) {
    if (value < 0.925) {
      return small;
    }

    if (value >= 1.10) {
      return large;
    }

    return normal;
  }

  // se aplica el tamaño del texto.
  static TextScaler getTextScaler(double value) {
    return TextScaler.linear(normalize(value));
  }
}
