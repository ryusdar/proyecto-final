import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
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

  Future<void> _load() async {
    final sellerId = product.sellerId;
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
      final v = await ApiClient.get('/api/vendedores/$sellerId')
          as Map<String, dynamic>;
      final data = await ApiClient.get('/api/productos/vendedor/$sellerId')
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
    final about =
        (_storeDescription != null && _storeDescription!.trim().isNotEmpty)
            ? _storeDescription!
            : 'Este artesano todavía no escribió una descripción.';

    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        maxWidth: 900,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 260),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            VyntaColors.brandPurple,
                            Color(0xFF9C5BFF),
                          ],
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
                                  Text(
                                    _sellerName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      color: VyntaColors.cardWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Artesano",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      _StatItem(
                                        icon: Icons.inventory_2,
                                        value: '${_products.length}',
                                        label: "Productos",
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

                    Padding(
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
                            child: Text(
                              about,
                              style: const TextStyle(
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
                              const Expanded(
                                child: Text(
                                  "Productos del taller",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: VyntaColors.ink,
                                  ),
                                ),
                              ),
                              Text(
                                '${_products.length}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: VyntaColors.brandPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          _productsSection(),
                        ],
                      ),
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
    );
  }

  Widget _productsSection() {
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
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              TextButton(onPressed: _load, child: const Text("Reintentar")),
            ],
          ),
        ),
      );
    }
    if (_products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("Este taller todavía no tiene productos")),
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
      itemBuilder: (_, i) => _sellerProduct(context, _products[i]),
    );
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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