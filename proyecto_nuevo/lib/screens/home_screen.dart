import 'dart:async';
import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/vynta_store.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

class VyntaProduct {
  final String name;
  final String price;
  final IconData icon;
  final int? id;
  final String? description;
  final int? sellerId;

  const VyntaProduct(
    this.name,
    this.price,
    this.icon, {
    this.id,
    this.description,
    this.sellerId,
  });

  factory VyntaProduct.fromJson(Map<String, dynamic> json) {
    final precio = (json['precio'] as num).toInt();
    return VyntaProduct(
      json['nombre'] as String,
      VyntaStore.instance.formatPrice(precio),
      VyntaCategory.iconForId((json['categoriaId'] as num?)?.toInt()),
      id: (json['id'] as num).toInt(),
      description: json['descripcion'] as String?,
      sellerId: (json['vendedorId'] as num?)?.toInt(),
    );
  }
}

class VyntaCategory {
  final int? id;
  final String name;
  final IconData icon;
  const VyntaCategory(this.name, this.icon, {this.id});

  static final Map<int, IconData> _iconsById = {};

  static IconData iconForId(int? id) =>
      _iconsById[id] ?? Icons.inventory_2_outlined;

  static IconData iconForName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'hogar':
        return Icons.chair;
      case 'tecnología':
      case 'tecnologia':
        return Icons.laptop_mac;
      case 'herramientas':
        return Icons.handyman;
      case 'manualidades':
        return Icons.palette;
      case 'decoración':
      case 'decoracion':
        return Icons.light_mode;
      default:
        return Icons.category_outlined;
    }
  }

  factory VyntaCategory.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num).toInt();
    final name = json['nombre'] as String;
    final icon = iconForName(name);
    _iconsById[id] = icon;
    return VyntaCategory(name, icon, id: id);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VyntaCategory> _categories = [];
  List<VyntaProduct> _products = [];
  bool _loading = true;
  bool _hasLoaded = false;
  String? _error;
  int _seenVersion = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seenVersion = VyntaStore.instance.catalogVersion;
    VyntaStore.instance.addListener(_onStoreChanged);
    _load();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && !_loading) _load();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    VyntaStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    final v = VyntaStore.instance.catalogVersion;
    if (v != _seenVersion) {
      _seenVersion = v;
      _load();
    }
  }

  Future<void> _load() async {
    // Spinner solo la primera vez; las recargas son silenciosas.
    if (!_hasLoaded) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final cats = await ApiClient.get('/api/categorias') as List<dynamic>;
      final categories = cats
          .map((e) => VyntaCategory.fromJson(e as Map<String, dynamic>))
          .toList();

      final data = await ApiClient.get('/api/productos') as List<dynamic>;
      final products = data
          .map((e) => VyntaProduct.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _products = products;
        _loading = false;
        _hasLoaded = true;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      // Si ya había datos, se conservan y no se muestra error.
      if (_hasLoaded) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: VyntaColors.navTeal,
      padding: const EdgeInsets.symmetric(
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
                    Expanded(
                      child: Text(
                        "Buscar productos…",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
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

  Widget _categoryCard(BuildContext context, VyntaCategory c) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryScreen(category: c)),
        );
      },
      child: SizedBox(
        width: 72,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: VyntaColors.ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  const SizedBox(height: 8),
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

  Widget _categoriesSection() {
    if (_categories.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text("Todavía no hay categorías")),
      );
    }
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _categoryCard(context, _categories[i]),
      ),
    );
  }

  Widget _productsSection() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
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
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text("Todavía no hay productos publicados")),
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
      itemBuilder: (_, i) => _productCard(context, _products[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        maxWidth: 900,
        child: Column(
          children: [
            _searchBar(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(VyntaColors.internalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 130),
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
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: VyntaColors.cardWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Hasta 30% OFF en manualidades",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                            const SizedBox(width: 8),
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

                      const Text(
                        "Categorías",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _categoriesSection(),

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

                      _productsSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
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
}