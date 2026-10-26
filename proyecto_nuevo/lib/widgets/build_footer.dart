import 'package:flutter/material.dart';

/// Antes mostraba la versión y la fecha del build.
/// Ahora no dibuja nada, pero se mantiene para no romper las pantallas
/// que lo usan.
class BuildFooter extends StatelessWidget {
  const BuildFooter({super.key, this.color = Colors.white54});

  final Color color;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}