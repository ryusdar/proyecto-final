import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../core/api_client.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

class SellerProfileScreen extends StatefulWidget {
  final VyntaProduct product;

  const SellerProfileScreen({super.key, required this.product});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  String? _storeName;
  String? _storeDescription;

  List<VyntaProduct> _products = [];

  bool _loading = true;
  String? _error;

  VyntaProduct get product => widget.product;

  String get _sellerName =>
      _storeName ?? 'Artesano ${product.name.split(' ').first}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  //se obtiene los datos del vendedor y sus productos del backend
  Future<void> _load() async {
    final sellerId = product.sellerId;

    // se mostramos elproducto
    if (sellerId == null) {
      setState(() {
        _products = [product];
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final v =
          await ApiClient.get('/api/vendedores/$sellerId')
              as Map<String, dynamic>;

      final data =
          await ApiClient.get('/api/productos/vendedor/$sellerId')
              as List<dynamic>;

      final list = data
          .map((e) => VyntaProduct.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;

      setState(() {
        _storeName = v['nombreTienda'] as String?;
        _storeDescription = v['descripcion'] as String?;
        _products = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //preferencias de accesibilidad
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    // Coloressegún el modo de accesibilidad
    final backgroundColor = AccessibilityColors.background(context);
    final textColor = AccessibilityColors.text(context);

    final about =
        (_storeDescription != null && _storeDescription!.trim().isNotEmpty)
        ? _storeDescription!
        : 'Este artesano todavía no escribió una descripción.';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AppFrame(
        color: backgroundColor,
        maxWidth: 900,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado del vendedor.
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 260),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
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
                          // Botn para regresar
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: VyntaColors.cardWhite,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          // Informacion del vendedor
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: VyntaColors.cardWhite
                                        .withValues(alpha: 0.25),
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

                                  // Nombre de la tienda o del artesano
                                  Text(
                                    _sellerName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19 * fontScale,
                                      color: VyntaColors.cardWhite,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    'Artesano',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13 * fontScale,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Cantidad de productos publicados
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _StatItem(
                                        icon: Icons.inventory_2,
                                        value: '${_products.length}',
                                        label: 'Productos',
                                        fontScale: fontScale,
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

                    // Informacion y productos del taller
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sobre mí',
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // descripcion del vendedor
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: VyntaColors.cardWhite,
                              borderRadius: BorderRadius.circular(
                                VyntaColors.radius,
                              ),
                            ),
                            child: Text(
                              about,
                              style: TextStyle(
                                fontSize: 14 * fontScale,
                                height: 1.5,
                                color: VyntaColors.ink,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Productos del taller',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16 * fontScale,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                '${_products.length}',
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: VyntaColors.brandPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          _productsSection(fontScale),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pie de pantalla
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: BuildFooter(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productsSection(double fontScale) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14 * fontScale,
                  color: AccessibilityColors.text(context),
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _load,
                child: Text(
                  'Reintentar',
                  style: TextStyle(fontSize: 14 * fontScale),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Este taller todavía no tiene productos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: AccessibilityColors.text(context),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.72,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => _sellerProduct(context, _products[i], fontScale),
    );
  }

  //producto publicado por el vendedor
  Widget _sellerProduct(
    BuildContext context,
    VyntaProduct p,
    double fontScale,
  ) {
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // producto con tamaño accesible
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12 * fontScale,
                      color: VyntaColors.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // se ajusta al ancho disponible
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      p.price,
                      style: TextStyle(
                        fontSize: 15 * fontScale,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
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

//muestra una estadística del perfil del vendedor
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double fontScale;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.fontScale,
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * fontScale,
                color: VyntaColors.cardWhite,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11 * fontScale),
        ),
      ],
    );
  }
}
