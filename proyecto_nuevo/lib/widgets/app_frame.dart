import 'package:flutter/material.dart';

/// Centra el contenido y limita su ancho máximo.
/// En celular ocupa todo el ancho; en pantallas grandes queda centrado.
class AppFrame extends StatelessWidget {
  final Widget child;
  final Color color;
  final double maxWidth;

  const AppFrame({
    super.key,
    required this.child,
    required this.color,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: color,
          child: child,
        ),
      ),
    );
  }
}