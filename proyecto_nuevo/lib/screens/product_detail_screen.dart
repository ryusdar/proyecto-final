import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'seller_profile_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';

class ProductDetailScreen extends StatelessWidget {
  final VyntaProduct product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
              // Imagen del producto con bordes redondeados (estilo referencia)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    decoration: const BoxDecoration(
                      color: VyntaColors.contentGrey,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Icon(
                      product.icon,
                      size: 150,
                      color: VyntaColors.brandPurple,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: VyntaColors.cardWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: VyntaColors.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Cuerpo
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.ink,
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: VyntaStore.instance,
                          builder: (context, _) {
                            final isFav = VyntaStore.instance.isFavorite(
                              product,
                            );
                            return IconButton(
                              onPressed: () =>
                                  VyntaStore.instance.toggleFavorite(product),
                              tooltip: isFav
                                  ? "Quitar de favoritos"
                                  : "Guardar",
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: VyntaColors.brandPurple,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating simulado
                    const Row(
                      children: [
                        Icon(Icons.star, size: 20, color: Color(0xFFF5A623)),
                        Icon(Icons.star, size: 20, color: Color(0xFFF5A623)),
                        Icon(Icons.star, size: 20, color: Color(0xFFF5A623)),
                        Icon(Icons.star, size: 20, color: Color(0xFFF5A623)),
                        Icon(
                          Icons.star_half,
                          size: 20,
                          color: Color(0xFFF5A623),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "4.7 · 128 reseñas",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Acerca de este producto",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.name}, una creación artesanal única hecha a mano, con '
                      'materiales de alta calidad y terminaciones cuidadas. Cada pieza '
                      'es original y personalizada para el comprador.',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Perfil del vendedor
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerProfileScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: VyntaColors.cardWhite,
                          borderRadius: BorderRadius.circular(
                            VyntaColors.radius,
                          ),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: VyntaColors.brandPurple,
                              child: Icon(
                                Icons.person,
                                color: VyntaColors.cardWhite,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Artesano",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Taller de ${product.name.split(' ').first}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: VyntaColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Ver perfil",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: VyntaColors.brandPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: VyntaColors.brandPurple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Acciones: agregar al carrito + comprar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: VyntaColors.cardWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    // Agregar al carrito
                    GestureDetector(
                      onTap: () {
                        VyntaStore.instance.addToCart(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1400),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: VyntaColors.brandPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  VyntaColors.radius,
                                ),
                              ),
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: VyntaColors.cardWhite,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${product.name.split(' ').first} se '
                                      'agregó al carrito',
                                      style: const TextStyle(
                                        color: VyntaColors.cardWhite,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                      },
                      child: Container(
                        width: 56,
                        height: 52,
                        decoration: BoxDecoration(
                          color: VyntaColors.contentGrey,
                          borderRadius: BorderRadius.circular(
                            VyntaColors.radius,
                          ),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: VyntaColors.brandPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
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
                            VyntaStore.instance.addToCart(product);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Comprar ahora",
                            style: TextStyle(
                              color: VyntaColors.ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
