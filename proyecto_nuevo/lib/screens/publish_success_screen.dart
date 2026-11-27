import 'package:flutter/material.dart';
import '../core/vynta_colors.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../widgets/app_frame.dart';

//confirmacion que el producto se publicó correctamente
class PublishSuccessScreen extends StatelessWidget {
  final String name;
  final String price;

  const PublishSuccessScreen({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // preferencias de accesibilidad
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    // Colores adaptados al modo de accesibilidad
    final backgroundColor = AccessibilityColors.background(context);
    final textColor = AccessibilityColors.text(context);
    final secondaryTextColor = AccessibilityColors.secondaryText(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AppFrame(
        color: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Evita que el contenido quede cortado en pantallas chicas
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34C759),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "¡Publicado!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22 * fontScale,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tu producto "$name" ($price) ya está en tu taller.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: secondaryTextColor,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Los compradores ya pueden encontrarlo '
                      'en las categorías y la búsqueda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13 * fontScale,
                        color: secondaryTextColor,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Boton para regresar al perfil
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VyntaColors.accentTurquoise,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            VyntaColors.radius,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),

                      onPressed: () {
                        //cerramos la confirmacion y el formulario de publicacion
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },

                      // Texto del boton con tamaño adaptable
                      child: Text(
                        "Volver",
                        style: TextStyle(
                          color: VyntaColors.ink,
                          fontWeight: FontWeight.bold,
                          fontSize: 15 * fontScale,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
