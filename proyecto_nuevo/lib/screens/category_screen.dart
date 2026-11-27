import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../core/text_size_manager.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

// Pantalla que muestra los productos de una categoría.
class CategoryScreen extends StatefulWidget {
  final VyntaCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<VyntaProduct> _products = [];

  bool _loading = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _load();
  }

  // Obtiene los productos correspondientes a la categoría.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final id = widget.category.id;

      // Comprobar que la categoría tenga un identificador válido.
      if (id == null) {
        throw ApiException('Categoría desconocida');
      }

      final data =
          await ApiClient.get('/api/productos/categoria/$id') as List<dynamic>;

      // Convertir los datos recibidos en objetos VyntaProduct.
      final list = data
          .map((e) => VyntaProduct.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;

      setState(() {
        _products = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      // Guardar el error para mostrarlo en pantalla.
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // Construye el contenido principal de la pantalla.
  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: AccessibilityColors.text(context)),
              ),

              const SizedBox(height: 8),

              TextButton(onPressed: _load, child: const Text("Reintentar")),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Todavía no hay productos en esta categoría",
            textAlign: TextAlign.center,
            style: TextStyle(color: AccessibilityColors.text(context)),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(14),

      itemCount: _products.length,

      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,

        // Cuando el texto es grande, las tarjetas tienen más altura.
        childAspectRatio:
            0.72 /
            TextSizeManager.normalize(AccessibilityScope.of(context).fontScale),

        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),

      // Construir una tarjeta por cada producto.
      itemBuilder: (_, i) {
        return _productCard(context, _products[i]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibility = AccessibilityScope.of(context);

    final category = widget.category;

    // Obtener el color de fondo según el tema elegido.
    final backgroundColor = AccessibilityColors.background(context);

    // Aplicar el tamaño de texto seleccionado a toda la pantalla.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextSizeManager.getTextScaler(accessibility.fontScale),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,

        body: AppFrame(
          color: backgroundColor,
          maxWidth: 900,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO DE LA CATEGORÍA.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
                color: VyntaColors.navTeal,

                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: VyntaColors.cardWhite,
                      ),
                    ),

                    Icon(category.icon, color: VyntaColors.cardWhite, size: 22),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: VyntaColors.cardWhite,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Cantidad de productos encontrados.
                    Text(
                      '${_products.length}',
                      style: const TextStyle(
                        color: VyntaColors.cardWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // CONTENIDO PRINCIPAL.
              Expanded(child: _body()),

              // PIE DE PÁGINA.
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

  // Construye la tarjeta individual de cada producto.
  Widget _productCard(BuildContext context, VyntaProduct p) {
    return GestureDetector(
      // Al seleccionar una tarjeta se abre el detalle del producto.
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
            // IMAGEN O ICONO DEL PRODUCTO.
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

            // INFORMACIÓN DEL PRODUCTO.
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

                  // FittedBox evita que los precios largos desborden.
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

                  // Botón visual para indicar que se puede comprar.
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
}
