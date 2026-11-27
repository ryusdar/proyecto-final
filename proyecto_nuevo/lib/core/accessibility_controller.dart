import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'text_size_manager.dart';

class AccessibilityController extends ChangeNotifier {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  bool isDarkMode = false;
  double fontScale = 1.0;

  // Cargar preferencias guardadas.
  Future<void> loadPreferences() async {
    isDarkMode = await _preferences.getBool('darkMode') ?? false;

    double savedSize =
        await _preferences.getDouble('fontScale') ?? TextSizeManager.normal;

    fontScale = TextSizeManager.normalize(savedSize);

    notifyListeners();
  }

  // Cambiar modo oscuro.
  Future<void> changeTheme(bool value) async {
    isDarkMode = value;

    notifyListeners();

    await _preferences.setBool('darkMode', value);
  }

  // Cambiar tamaño del texto.
  Future<void> changeFontSize(double value) async {
    fontScale = value;

    notifyListeners();

    await _preferences.setDouble('fontScale', value);
  }

  // Tema global de la aplicación.
  ThemeData get currentTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7A39FA),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),

      scaffoldBackgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF3F4F6),
    );
  }
}

// Acceso global al controlador de accesibilidad.
class AccessibilityScope extends InheritedNotifier<AccessibilityController> {
  const AccessibilityScope({
    super.key,
    required AccessibilityController controller,
    required super.child,
  }) : super(notifier: controller);

  static AccessibilityController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AccessibilityScope>();

    assert(scope != null, 'AccessibilityScope no encontrado');

    return scope!.notifier!;
  }
}
