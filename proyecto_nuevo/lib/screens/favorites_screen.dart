import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../widgets/build_footer.dart';

class FavoritesScreen extends StatelessWidget {
  /// Si es falso no muestra el botón de volver.
  final bool showBack;
  const FavoritesScreen({super.key, this.showBack = true});

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 72, color: VyntaColors.contentGrey),
          SizedBox(height: 16),
          Text(
            "Aún no tenés favoritos",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: VyntaColors.ink,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Tocá el corazón en un producto\npara guardarlo acá.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: VyntaStore.instance,
      builder: (context, _) {
        final store = VyntaStore.instance;
        final favorites = store.favorites;

        return Scaffold(
          backgroundColor: VyntaColors.contentGrey,
          body: Center(
            child: Container(
              width: 390,
              height: double.infinity,
              color: VyntaColors.contentGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
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
                          ),
                        const Icon(
                          Icons.favorite,
                          color: VyntaColors.cardWhite,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Mis favoritos",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: VyntaColors.cardWhite,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favoritos (o vacío)
                  Expanded(
                    child: favorites.isEmpty
                        ? _emptyState()
                        : GridView.builder(
                            padding: const EdgeInsets.all(14),
                            itemCount: favorites.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                            itemBuilder: (_, i) =>
                                _favoriteCard(context, favorites[i]),
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
                  // Quitar de favoritos
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => VyntaStore.instance.toggleFavorite(p),
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
            Padding(
              padding: const EdgeInsets.all(12),
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
                  Text(
                    p.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: VyntaColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 36,
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
