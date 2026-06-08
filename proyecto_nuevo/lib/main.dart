import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const VyntaApp());
}

class VyntaApp extends StatelessWidget {
  const VyntaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}