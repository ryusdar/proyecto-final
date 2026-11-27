import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

// Pantalla de busqueda de productos
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  int _requestId = 0;

  List<VyntaProduct> _results = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    //se muestran todos los productos
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // tarda 350 milisegundos antes de realizar la busqueda y evitar que se realicen muchas consultas a la vez

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  // Consulta los productos al backend
  Future<void> _search(String query) async {
    final q = query.trim();
    final myRequest = ++_requestId;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final path = q.isEmpty
          ? '/api/productos'
          : '/api/productos/buscar?nombre=${Uri.encodeQueryComponent(q)}';

      final data = await ApiClient.get(path) as List<dynamic>;

      final list = data
          .map((e) => VyntaProduct.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted || myRequest != _requestId) return;

      setState(() {
        _results = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || myRequest != _requestId) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // Contenido principal
  Widget _body(double fontScale) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                onPressed: () => _search(_controller.text),
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

    if (_results.isEmpty) {
      return const _NoResults();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _results.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.72,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => _resultCard(context, _results[i], fontScale),
    );
  }

  @override
  Widget build(BuildContext context) {
    //preferencias de accesibilidad
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    // El fondo cambia segvn el tema seleccionado
    final backgroundColor = AccessibilityColors.background(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AppFrame(
        color: backgroundColor,
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con campo de bisqueda
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(4, 8, 18, 14),
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
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: VyntaColors.cardWhite,
                        borderRadius: BorderRadius.circular(VyntaColors.radius),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: _onChanged,
                        onSubmitted: _search,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: VyntaColors.ink,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buscar manualidades…',
                          hintStyle: TextStyle(
                            fontSize: 14 * fontScale,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Resultados de la busqueda
            Expanded(child: _body(fontScale)),

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

  /// Tarjeta de cada producto
  Widget _resultCard(BuildContext context, VyntaProduct p, double fontScale) {
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
                  //nombre del producto
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

                  // se usa el FittedBox para evita que se desborden la tarjetas
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

//muestra cuando no hay productos para la busqueda
class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    // Colores para que el mensaje se adapte al modo accesible
    final textColor = AccessibilityColors.text(context);
    final secondaryTextColor = AccessibilityColors.secondaryText(context);

    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: VyntaColors.contentGrey,
            ),
            const SizedBox(height: 12),
            Text(
              'No encontramos productos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Probá con otra búsqueda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14 * fontScale,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
