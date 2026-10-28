import 'package:flutter/material.dart';
import '../core/vynta_colors.dart';
import '../widgets/app_frame.dart';

/// Confirmación de que el producto se publicó con éxito.
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
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                      child: const Icon(
                        Icons.check,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "¡Publicado!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Tu producto "$name" ($price) ya está en tu taller.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Los compradores ya pueden encontrarlo\nen las categorías y la búsqueda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VyntaColors.accentTurquoise,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(VyntaColors.radius),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // cierra el éxito
                        Navigator.of(context).pop(); // cierra el formulario
                      },
                      child: const Text(
                        "Volver",
                        style: TextStyle(
                          color: VyntaColors.ink,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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