import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'seller_profile_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
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

    // Consultamos los datos del vendedor
    _loadSeller();
  }
  // OBTENER INFORMACIÓN DEL VENDEDOR

  Future<void> _loadSeller() async {
    final sellerId = product.sellerId;

    // Si el producto no tiene vendedor asignado, no hacemos la consulta
    if (sellerId == null) return;

    try {
      final v =
          await ApiClient.get('/api/vendedores/$sellerId')
              as Map<String, dynamic>;

      if (!mounted) return;

      setState(() {
        _storeName = v['nombreTienda'] as String?;
      });
    } catch (_) {
      // Si falla la consulta, se mantiene el nombre predeterminado
    }
  }

  @override
  Widget build(BuildContext context) {
    // controlador global de accesibilidad
    final accessibility = AccessibilityScope.of(context);

    // Tamaño de letra seleccionado por el usuario
    final fontScale = accessibility.fontScale;

    // Descripcion del producto.
    final description =
        (product.description != null && product.description!.isNotEmpty)
        ? product.description!
        : '${product.name}, una creación artesanal única hecha a mano.';

    // Colores segun el modo de accesibilidad
    final backgroundColor = AccessibilityColors.background(context);

    final textColor = AccessibilityColors.text(context);

    final secondaryTextColor = AccessibilityColors.secondaryText(context);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: AppFrame(
        color: backgroundColor,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // CONTENIDO DESPLAZABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // IMAGEN DEL PRODUCTO
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

                        // BOTON PARA VOLVER
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
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              tooltip: 'Volver',

                              icon: const Icon(
                                Icons.arrow_back,
                                color: VyntaColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // INFORMACION DEL PRODUCTO
                    Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // NOMBRE Y FAVORITOS
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Expanded(
                                child: Text(
                                  product.name,

                                  //el nombre ocupe varias líneas
                                  softWrap: true,

                                  style: TextStyle(
                                    fontSize: 20 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),

                              // BOTON DE FAVORITOS
                              ListenableBuilder(
                                listenable: VyntaStore.instance,

                                builder: (context, _) {
                                  final isFav = VyntaStore.instance.isFavorite(
                                    product,
                                  );

                                  return IconButton(
                                    onPressed: () {
                                      VyntaStore.instance.toggleFavorite(
                                        product,
                                      );
                                    },

                                    tooltip: isFav
                                        ? "Quitar de favoritos"
                                        : "Guardar en favoritos",

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

                          // CALIFICACION DEL PRODUCTO
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,

                            spacing: 8,

                            children: [
                              // Estrellas de valoracion
                              const Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color(0xFFF5A623),
                                  ),

                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color(0xFFF5A623),
                                  ),

                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color(0xFFF5A623),
                                  ),

                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Color(0xFFF5A623),
                                  ),

                                  Icon(
                                    Icons.star_half,
                                    size: 20,
                                    color: Color(0xFFF5A623),
                                  ),
                                ],
                              ),

                              Text(
                                "4.7 · 128 reseñas",

                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 13 * fontScale,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // PRECIO DEL PRODUCTO
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,

                            child: Text(
                              product.price,

                              style: TextStyle(
                                fontSize: 26 * fontScale,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // TITULO DE LA DESCRIPCIÓN
                          Text(
                            "Acerca de este producto",

                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // DESCRIPCION DEL PRODUCTO
                          Text(
                            description,

                            softWrap: true,

                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              height: 1.5,
                              color: secondaryTextColor,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // PERFIL DEL VENDEDOR
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
                                  // Imagen del vendedor
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

                                  // Nombre de la tienda
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "Artesano",

                                          style: TextStyle(
                                            fontSize: 11 * fontScale,
                                            color: secondaryTextColor,
                                          ),
                                        ),

                                        Text(
                                          _storeName ??
                                              "Taller de ${product.name.split(' ').first}",

                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,

                                          style: TextStyle(
                                            fontSize: 14 * fontScale,
                                            fontWeight: FontWeight.w600,
                                            color: VyntaColors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Acceso al perfil
                                  Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      Text(
                                        "Ver perfil",

                                        style: TextStyle(
                                          fontSize: 13 * fontScale,
                                          color: VyntaColors.brandPurple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const Icon(
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

            // BOTONES FIJOS EN LA PARTE INFERIOR
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: const BoxDecoration(
                color: VyntaColors.cardWhite,

                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),

              child: Row(
                children: [
                  // AGREGAR AL CARRITO
                  GestureDetector(
                    onTap: () {
                      // Agregamos el producto al carrito
                      VyntaStore.instance.addToCart(product);

                      // Mostramos una notificacion
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

                                    style: TextStyle(
                                      color: VyntaColors.cardWhite,
                                      fontSize: 14 * fontScale,
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

                        borderRadius: BorderRadius.circular(VyntaColors.radius),
                      ),

                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: VyntaColors.brandPurple,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // BOTON COMPRAR AHORA
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
                          // Agregamos el producto al carrito
                          VyntaStore.instance.addToCart(product);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },

                        child: FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            "Comprar ahora",

                            style: TextStyle(
                              color: VyntaColors.ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * fontScale,
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
