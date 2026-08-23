import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../core/vynta_colors.dart';

class CheckoutConfirmationScreen extends StatelessWidget {
  final String total;
  final String method;

  const CheckoutConfirmationScreen({
    super.key,
    required this.total,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: Center(
        child: Container(
          width: 390,
          height: double.infinity,
          color: VyntaColors.contentGrey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Check de éxito
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Color(0xFF34C759),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 56, color: Colors.white),
                ),
                const SizedBox(height: 24),

                const Text(
                  "¡Compra confirmada!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: VyntaColors.ink,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Pagaste $total con $method.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'El vendedor te va a contactar para coordinar\n la entrega. ¡Gracias por comprar artesanal!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.5,
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
                        borderRadius: BorderRadius.circular(VyntaColors.radius),
                      ),
                    ),
                    onPressed: () {
                      // Volver al shell (inicio), limpia la pila.
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
        ),
      ),
    );
  }
}
