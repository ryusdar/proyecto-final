import 'package:flutter/material.dart';


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