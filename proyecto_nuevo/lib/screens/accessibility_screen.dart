import 'package:flutter/material.dart';
import '../core/accessibility_controller.dart';
import '../core/text_size_manager.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibility = AccessibilityScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedSize = TextSizeManager.normalize(accessibility.fontScale);

    return Scaffold(
      appBar: AppBar(title: const Text('Accesibilidad')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Apariencia',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Modo oscuro'),
              subtitle: const Text(
                'Cambiar el fondo de la aplicación a oscuro',
              ),
              value: accessibility.isDarkMode,
              onChanged: (value) {
                accessibility.changeTheme(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Tamaño del texto',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Elegí el tamaño de letra'),

                  const SizedBox(height: 16),

                  SegmentedButton<double>(
                    showSelectedIcon: false,

                    segments: const [
                      ButtonSegment<double>(
                        value: TextSizeManager.small,
                        label: Text('Pequeño'),
                      ),

                      ButtonSegment<double>(
                        value: TextSizeManager.normal,
                        label: Text('Normal'),
                      ),

                      ButtonSegment<double>(
                        value: TextSizeManager.large,
                        label: Text('Grande'),
                      ),
                    ],

                    selected: {selectedSize},

                    onSelectionChanged: (selection) {
                      accessibility.changeFontSize(selection.first);
                    },
                  ),

                  const SizedBox(height: 24),

                  const Divider(),

                  const SizedBox(height: 12),

                  const Text(
                    'Vista previa',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Así se verá el texto en Vynta.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Los cambios se guardan automáticamente.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
        ],
      ),
    );
  }
}
