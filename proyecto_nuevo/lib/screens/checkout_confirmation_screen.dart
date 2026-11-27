import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../core/vynta_colors.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../core/text_size_manager.dart';
import '../widgets/app_frame.dart';

/// Pantalla que confirma que la compra se realizó correctamente.
class CheckoutConfirmationScreen extends StatelessWidget {
  final String total;

  final String method;

  // Identificador del pedido generado por el backend.
  final int? orderId;

  const CheckoutConfirmationScreen({
    super.key,
    required this.total,
    required this.method,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener las preferencias de la accesibilidad.
    final accessibility = AccessibilityScope.of(context);

    // Obtener los colores según el tema seleccionado gris o negro.
    final backgroundColor = AccessibilityColors.background(context);
    final textColor = AccessibilityColors.text(context);
    final secondaryTextColor = AccessibilityColors.secondaryText(context);

    // Aplicar el tamaño de texto seleccionado a toda la pantalla.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextSizeManager.getTextScaler(accessibility.fontScale),
      ),

      child: Scaffold(
        backgroundColor: backgroundColor,

        body: AppFrame(
          color: backgroundColor,

          child: LayoutBuilder(
            builder: (context, constraints) {
              // Permite movimientos del contenido cuando el tamaño es  grande
              return SingleChildScrollView(
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
                        "¡Compra confirmada!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Pagaste $total con $method.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (orderId != null)
                        Text(
                          'Pedido #$orderId',
                          style: TextStyle(
                            fontSize: 13,
                            color: secondaryTextColor,
                          ),
                        ),

                      const SizedBox(height: 36),

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VyntaColors.accentTurquoise,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                VyntaColors.radius,
                              ),
                            ),
                          ),

                          onPressed: () {
                            // Volver al inicio y limpiar el historial
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const MainShell(),
                              ),
                              (route) => false,
                            );
                          },

                          child: const Text(
                            "Volver al inicio",
                            style: TextStyle(
                              color: VyntaColors.ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
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
      ),
    );
  }
}
