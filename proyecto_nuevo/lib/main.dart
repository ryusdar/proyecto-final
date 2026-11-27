import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'core/accessibility_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final accessibilityController = AccessibilityController();

  await accessibilityController.loadPreferences();

  runApp(VyntaApp(accessibilityController: accessibilityController));
}

class VyntaApp extends StatelessWidget {
  final AccessibilityController accessibilityController;

  const VyntaApp({super.key, required this.accessibilityController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: accessibilityController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: accessibilityController.currentTheme,

          builder: (context, child) {
            return AccessibilityScope(
              controller: accessibilityController,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  // para evitar valores repetidos
                  textScaler: TextScaler.linear(
                    accessibilityController.fontScale,
                  ),
                ),
                child: child!,
              ),
            );
          },

          home: const LoginScreen(),
        );
      },
    );
  }
}
