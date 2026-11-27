import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../core/text_size_manager.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

// Pantalla que muestra los productos guardados como favoritos.
class FavoritesScreen extends StatelessWidget {
  final bool showBack;

  const FavoritesScreen({super.key, this.showBack = true});

  // contenido que se muestra al usuario todavía no tiene productos favoritos.
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 72,
              color: VyntaColors.contentGrey,
            ),

            const SizedBox(height: 16),

            Text(
              "Aún no tenés favoritos",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AccessibilityColors.text(context),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Tocá el corazón en un producto\npara guardarlo acá.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AccessibilityColors.secondaryText(context),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibility = AccessibilityScope.of(context);

    //actualiza la pantalla cuando se agrega o elimina un producto a favoritos
    return ListenableBuilder(
      listenable: VyntaStore.instance,

      builder: (context, _) {
        final store = VyntaStore.instance;

        final favorites = store.favorites;

        // Obtener el color de fondo según el tema seleccionado.
        final backgroundColor = AccessibilityColors.background(context);

        // Normalizar el tamaño de texto seleccionado.
        final fontScale = TextSizeManager.normalize(accessibility.fontScale);

        // Aplicar el tamaño de texto a toda la pantalla.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextSizeManager.getTextScaler(accessibility.fontScale),
          ),

          child: Scaffold(
            backgroundColor: backgroundColor,

            body: AppFrame(
              color: backgroundColor,
              maxWidth: 900,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
                    color: VyntaColors.navTeal,

                    child: Row(
                      children: [
                        if (showBack)
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: VyntaColors.cardWhite,
                            ),
                          )
                        else
                          const SizedBox(width: 14),

                        const Icon(
                          Icons.favorite,
                          color: VyntaColors.cardWhite,
                        ),

                        const SizedBox(width: 6),

                        const Expanded(
                          child: Text(
                            "Mis favoritos",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.cardWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    // Si no hay favoritos se muestrar mensaje.
                    child: favorites.isEmpty
                        ? _emptyState(context)
                        : GridView.builder(
                            padding: const EdgeInsets.all(14),

                            itemCount: favorites.length,

                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,

                              // Aumenta la altura cuando se selecciona texto grande.
                              childAspectRatio: 0.72 / fontScale,

                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),

                            itemBuilder: (_, i) {
                              return _favoriteCard(context, favorites[i]);
                            },
                          ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: BuildFooter(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Se Construye la tarjeta para  cada producto favorito

  Widget _favoriteCard(BuildContext context, VyntaProduct p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: p),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: VyntaColors.cardWhite,
          borderRadius: BorderRadius.circular(VyntaColors.radius),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: VyntaColors.contentGrey,
                      borderRadius: BorderRadius.circular(
                        VyntaColors.radiusSmall,
                      ),
                    ),

                    child: Icon(
                      p.icon,
                      size: 52,
                      color: VyntaColors.brandPurple,
                    ),
                  ),

                  Positioned(
                    top: 4,
                    right: 4,

                    child: GestureDetector(
                      // Actualizar la lista de favoritos
                      onTap: () {
                        VyntaStore.instance.toggleFavorite(p);
                      },

                      child: Container(
                        padding: const EdgeInsets.all(5),

                        decoration: const BoxDecoration(
                          color: VyntaColors.cardWhite,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 18,
                          color: VyntaColors.brandPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // INFORMACIÓN DEL PRODUCTO.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Precio del producto.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,

                    child: Text(
                      p.price,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // BOTÓN VISUAL DE COMPRA.
                  Container(
                    width: double.infinity,
                    height: 34,
                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: VyntaColors.accentTurquoise,
                      borderRadius: BorderRadius.circular(
                        VyntaColors.radiusSmall,
                      ),
                    ),

                    child: const Text(
                      "Comprar",
                      style: TextStyle(
                        color: VyntaColors.ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
