import 'package:flutter/material.dart';
import '../core/build_info.dart';

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
