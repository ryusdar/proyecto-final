import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'seller_profile_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../widgets/app_frame.dart';

class ProductDetailScreen extends StatefulWidget {
  final VyntaProduct product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _storeName;

  VyntaProduct get product => widget.product;

  @override
  void initState() {
    super.initState();
    _loadSeller();
  }

  Future<void> _loadSeller() async {
    final sellerId = product.sellerId;
    if (sellerId == null) return;
    try {
      final v = await ApiClient.get('/api/vendedores/$sellerId')
          as Map<String, dynamic>;
      if (!mounted) return;
      setState(() => _storeName = v['nombreTienda'] as String?);
    } catch (_) {
      // Si falla, se queda con el texto por defecto.
    }
  }

  @override
  Widget build(BuildContext context) {
    final description =
        (product.description != null && product.description!.isNotEmpty)
            ? product.description!
            : '${product.name}, una creación artesanal única hecha a mano.';

    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del producto con bordes redondeados
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                          constraints: const BoxConstraints(maxHeight: 320),
                          child: AspectRatio(
                            aspectRatio: 1.2,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: VyntaColors.contentGrey,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Icon(
                                    product.icon,
                                    size: 150,
                                    color: VyntaColors.brandPurple,
                                  ),
                                ),
                              ),
                            ),
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
                                  final isFav =
                                      VyntaStore.instance.isFavorite(product);
                                  return IconButton(
                                    onPressed: () => VyntaStore.instance
                                        .toggleFavorite(product),
                                    tooltip: isFav
                                        ? "Quitar de favoritos"
                                        : "Guardar",
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: VyntaColors.brandPurple,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Rating
                          const Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      size: 20, color: Color(0xFFF5A623)),
                                  Icon(Icons.star,
                                      size: 20, color: Color(0xFFF5A623)),
                                  Icon(Icons.star,
                                      size: 20, color: Color(0xFFF5A623)),
                                  Icon(Icons.star,
                                      size: 20, color: Color(0xFFF5A623)),
                                  Icon(Icons.star_half,
                                      size: 20, color: Color(0xFFF5A623)),
                                ],
                              ),
                              Text(
                                "4.7 · 128 reseñas",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product.price,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: VyntaColors.ink,
                              ),
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
                            description,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Artesano",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          _storeName ??
                                              "Taller de ${product.name.split(' ').first}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: VyntaColors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                  ],
                ),
              ),
            ),

            // Acciones: agregar al carrito + comprar (fijas abajo)
            Container(
              width: double.infinity,
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
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
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