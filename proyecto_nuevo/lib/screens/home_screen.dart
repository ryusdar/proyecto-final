import 'dart:async';
import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/vynta_store.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
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

  // Convierte los datos JSON recibidos de la API en un objeto Producto
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

  // Asigna un icono dependiendo del nombre de la categoría.
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

  // Convierte la categoria recibida desde el backend.
  factory VyntaCategory.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num).toInt();
    final name = json['nombre'] as String;
    final icon = iconForName(name);

    _iconsById[id] = icon;

    return VyntaCategory(name, icon, id: id);
  }
}

// PANTALLA PRINCIPAL

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Listas que almacenan los datos recibidos del backend
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

    // Actualiza el catalogo
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && !_loading) {
        _load();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    VyntaStore.instance.removeListener(_onStoreChanged);

    super.dispose();
  }

  // Detecta si hubo modificaciones en el catalogo
  void _onStoreChanged() {
    final v = VyntaStore.instance.catalogVersion;

    if (v != _seenVersion) {
      _seenVersion = v;
      _load();
    }
  }

  // OBTENER DATOS DEL BACKEND
  Future<void> _load() async {
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

      // Si habia informacion se conservan los datos anteriores
      if (_hasLoaded) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // BARRA DE BUSQUEDA

  Widget _searchBar(BuildContext context, double fontScale) {
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
                height: 48,

                decoration: BoxDecoration(
                  color: VyntaColors.cardWhite,
                  borderRadius: BorderRadius.circular(VyntaColors.radius),
                ),

                child: Row(
                  children: [
                    const SizedBox(width: 14),

                    const Icon(Icons.search, color: Colors.grey, size: 20),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Buscar productos…",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: Colors.grey,
                        ),
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

  // CATEGORIA

  Widget _categoryCard(
    BuildContext context,
    VyntaCategory c,
    double fontScale,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryScreen(category: c)),
        );
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 11 * fontScale,
              color: AccessibilityColors.text(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // PRODUCTO

  Widget _productCard(BuildContext context, VyntaProduct p, double fontScale) {
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
            // Espacio de icono del producto
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

                    style: TextStyle(
                      fontSize: 12 * fontScale,
                      color: AccessibilityColors.text(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

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

                  const SizedBox(height: 8),

                  // Boton de compra
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 34),
                    alignment: Alignment.center,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: VyntaColors.accentTurquoise,
                      borderRadius: BorderRadius.circular(
                        VyntaColors.radiusSmall,
                      ),
                    ),

                    child: Text(
                      "Comprar",

                      style: TextStyle(
                        color: VyntaColors.ink,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * fontScale,
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

  // SECCION DE CATEGORÍAS RESPONSIVE

  Widget _categoriesSection(double fontScale) {
    if (_categories.isEmpty) {
      return SizedBox(
        height: 60,

        child: Center(
          child: Text(
            "Todavía no hay categorías",

            style: TextStyle(
              fontSize: 14 * fontScale,
              color: AccessibilityColors.text(context),
            ),
          ),
        ),
      );
    }

    // Wrap acomoda las categorías en varias filas el espacio disponible en la pantalla.
    return Wrap(
      spacing: 8,
      runSpacing: 14,
      alignment: WrapAlignment.start,

      children: _categories.map((category) {
        return SizedBox(
          width: 120,

          child: _categoryCard(context, category, fontScale),
        );
      }).toList(),
    );
  }

  // SECCION DE PRODUCTOS

  Widget _productsSection(double fontScale) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),

        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Mensaje en caso de error de conexion
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),

        child: Center(
          child: Column(
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AccessibilityColors.text(context),
                  fontSize: 14 * fontScale,
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _load,

                child: Text(
                  "Reintentar",
                  style: TextStyle(fontSize: 14 * fontScale),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mensaje cuando todavía no existen productos
    if (_products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),

        child: Center(
          child: Text(
            "Todavía no hay productos publicados",

            style: TextStyle(
              color: AccessibilityColors.text(context),
              fontSize: 14 * fontScale,
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

        // Aumenta la altura de la tarjeta para los textos grandes
        childAspectRatio: 0.68,

        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),

      itemBuilder: (_, i) {
        return _productCard(context, _products[i], fontScale);
      },
    );
  }

  // CONSTRUCCION DE LA PANTALLA PRINCIPAL

  @override
  Widget build(BuildContext context) {
    // Controlador global de accesibilidad
    final accessibility = AccessibilityScope.of(context);

    // Obtenemos el tamaño de letra seleccionado
    final fontScale = accessibility.fontScale;

    return Scaffold(
      backgroundColor: AccessibilityColors.background(context),

      body: AppFrame(
        color: AccessibilityColors.background(context),
        maxWidth: 900,

        child: Column(
          children: [
            // Barra de busqueda
            _searchBar(context, fontScale),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(VyntaColors.internalPadding),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //BANNER DE OFERTAS
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
                                  Text(
                                    "Ofertas de la semana",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: VyntaColors.cardWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18 * fontScale,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Hasta 30% OFF en manualidades",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12 * fontScale,
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

                                    child: Text(
                                      "Ver ofertas",

                                      style: TextStyle(
                                        color: VyntaColors.ink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11 * fontScale,
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

                      Text(
                        "Categorías",

                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.bold,
                          color: AccessibilityColors.text(context),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _categoriesSection(fontScale),

                      const SizedBox(height: 24),

                      Text(
                        "Lo más vendido",

                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.bold,
                          color: AccessibilityColors.text(context),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _productsSection(fontScale),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // PIE DE PAGINA
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
