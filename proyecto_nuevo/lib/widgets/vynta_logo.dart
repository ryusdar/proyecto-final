import 'package:flutter/material.dart';

class VyntaLogo extends StatelessWidget {
  final double width;

  const VyntaLogo({
    super.key,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/vynta_logo.png',
        width: width,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}