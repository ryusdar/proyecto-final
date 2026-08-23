import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../widgets/build_footer.dart';

/// Perfil del vendedor (artesano) que publicó un producto.
/// Es un mock: se deriva del producto que se abre desde el detalle.
class SellerProfileScreen extends StatelessWidget {
  final VyntaProduct product;
  const SellerProfileScreen({super.key, required this.product});

  /// Nombre del vendedor derivado del taller (mock).
  String get _sellerName => 'Artesano ${product.name.split(' ').first}';

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
            children: [
              // Header del vendedor — morado degradado (brand).
              Container(
                width: double.infinity,
                height: 260,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [VyntaColors.brandPurple, Color(0xFF9C5BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: VyntaColors.cardWhite,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: VyntaColors.cardWhite.withValues(
                              alpha: 0.25,
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: VyntaColors.cardWhite,
                              child: Icon(
                                Icons.brush,
                                size: 40,
                                color: VyntaColors.brandPurple,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _sellerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: VyntaColors.cardWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Artesano · Miembro desde 2023",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StatItem(
                                icon: Icons.inventory_2,
                                value: "24",
                                label: "Productos",
                              ),
                              const SizedBox(width: 28),
                              _StatItem(
                                icon: Icons.star,
                                value: "4.8",
                                label: "Calificación",
                              ),
                              const SizedBox(width: 28),
                              _StatItem(
                                icon: Icons.shopping_bag,
                                value: "312",
                                label: "Ventas",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sobre mí",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: VyntaColors.cardWhite,
                          borderRadius: BorderRadius.circular(
                            VyntaColors.radius,
                          ),
                        ),
                        child: const Text(
                          "Hacé tus manualidades con las manos y el corazón. "
                          "Cada pieza es única, trabajada con materiales nobles "
                          "y un acabado cuidado. Acepto pedidos personalizados.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: VyntaColors.ink,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Productos del taller",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.ink,
                            ),
                          ),
                          Text(
                            '${_sellerProducts().length}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: VyntaColors.brandPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Grid de productos del vendedor (reutiliza los del home)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sellerProducts().length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemBuilder: (_, i) =>
                            _sellerProduct(context, _sellerProducts()[i]),
                      ),
                    ],
                  ),
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
  }

  /// Productos del vendedor: mock, todos los del home salvo el "actual" se
  /// muestran como del mismo taller. En un MVP con backend se filtraría por vendedor.
  List<VyntaProduct> _sellerProducts() {
    final all = HomeScreen.products;
    // Muestra un subconjunto representativo (hasta 4) incluyendo el actual.
    final sample = <VyntaProduct>[];
    sample.add(product);
    for (final p in all) {
      if (p.name != product.name && sample.length < 4) {
        sample.add(p);
      }
    }
    return sample;
  }

  Widget _sellerProduct(BuildContext context, VyntaProduct p) {
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
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: VyntaColors.contentGrey,
                  borderRadius: BorderRadius.circular(VyntaColors.radiusSmall),
                ),
                child: Icon(p.icon, size: 52, color: VyntaColors.brandPurple),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ítem de estadística del header del vendedor.
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: VyntaColors.accentTurquoise),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: VyntaColors.cardWhite,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
