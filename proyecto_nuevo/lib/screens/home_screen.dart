import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import '../core/vynta_colors.dart';
import '../widgets/build_footer.dart';

class VyntaProduct {
  final String name;
  final String price;
  final IconData icon;
  const VyntaProduct(this.name, this.price, this.icon);
}

class VyntaCategory {
  final String name;
  final IconData icon;
  const VyntaCategory(this.name, this.icon);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<VyntaCategory> categories = [
    VyntaCategory("Hogar", Icons.chair),
    VyntaCategory("Tecnología", Icons.laptop_mac),
    VyntaCategory("Herramientas", Icons.handyman),
    VyntaCategory("Manualidades", Icons.palette),
    VyntaCategory("Decoración", Icons.light_mode),
  ];

  static const List<VyntaProduct> products = [
    VyntaProduct("Sillón de cuero ultra delgado", "\$ 150.000", Icons.weekend),
    VyntaProduct("Computadora gamer", "\$ 650.000", Icons.computer),
    VyntaProduct("Maceta artesanal", "\$ 8.500", Icons.local_florist),
    VyntaProduct("Velas aromáticas", "\$ 4.200", Icons.local_fire_department),
    VyntaProduct("Banquito de madera", "\$ 12.000", Icons.chair_outlined),
    VyntaProduct("Cuadro tejido", "\$ 9.800", Icons.image),
  ];

  /// Barra de búsqueda superior — color de navegación (teal), unificado.
  /// Al tocarla abre la pantalla de Búsqueda completa.
  Widget _searchBar(BuildContext context) {
    return Container(
      color: VyntaColors.navTeal,
      padding: EdgeInsets.symmetric(
        horizontal: VyntaColors.internalPadding,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: VyntaColors.cardWhite,
                  borderRadius: BorderRadius.circular(VyntaColors.radius),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 14),
                    Icon(Icons.search, color: Colors.grey, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Buscar productos…",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.notifications_outlined,
              color: VyntaColors.cardWhite,
            ),
          ),
        ],
      ),
    );
  }

  /// Card de categoría (icono + nombre), estilo tile de referencia.
  Widget _categoryCard(BuildContext context, VyntaCategory c) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryScreen(category: c)),
        );
      },
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: VyntaColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(c.icon, size: 28, color: VyntaColors.brandPurple),
          ),
          const SizedBox(height: 8),
          Text(
            c.name,
            style: const TextStyle(
              fontSize: 11,
              color: VyntaColors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Card de producto en grid (imagen + nombre + precio), estilo referencia.
  /// Al tocarla abre el Detalle de producto.
  Widget _productCard(BuildContext context, VyntaProduct p) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: Center(
        child: Container(
          width: 390,
          color: VyntaColors.contentGrey,
          child: Column(
            children: [
              _searchBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(VyntaColors.internalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner de productos recomendados
                      Container(
                        width: double.infinity,
                        height: 130,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              VyntaColors.brandPurple,
                              Color(0xFF9C5BFF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            VyntaColors.radius,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Ofertas de la semana",
                                    style: TextStyle(
                                      color: VyntaColors.cardWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Hasta 30% OFF en manualidades",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: VyntaColors.accentTurquoise,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Ver ofertas",
                                      style: TextStyle(
                                        color: VyntaColors.ink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.volunteer_activism,
                              size: 80,
                              color: VyntaColors.cardWhite.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categorías",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.ink,
                            ),
                          ),
                          const Text(
                            "Ver todas",
                            style: TextStyle(
                              fontSize: 12,
                              color: VyntaColors.brandPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (_, i) =>
                              _categoryCard(context, categories[i]),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Lo más vendido",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemBuilder: (_, i) =>
                            _productCard(context, products[i]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Pie de versión (oscuro sobre fondo claro)
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
}
