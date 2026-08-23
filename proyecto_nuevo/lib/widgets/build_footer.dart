import 'package:flutter/material.dart';
import '../core/build_info.dart';

/// Pie de versión — muestra el commit con el que se compiló el build en vivo,
/// para saber siempre qué versión se está viendo en el mini-server.
class BuildFooter extends StatelessWidget {
  const BuildFooter({super.key, this.color = Colors.white54});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'v$kBuildCommit · $kBuildDate',
      style: TextStyle(fontSize: 10, color: color, letterSpacing: 0.5),
    );
  }
}
