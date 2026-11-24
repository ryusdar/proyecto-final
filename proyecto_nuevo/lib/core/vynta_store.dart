import 'package:flutter/foundation.dart';
import '../screens/home_screen.dart';
import 'api_client.dart';

class CartItem {
  final VyntaProduct product;
  int quantity;
  CartItem(this.product, this.quantity);
}

class VyntaStore extends ChangeNotifier {
  VyntaStore._();
  static final VyntaStore instance = VyntaStore._();

  final List<CartItem> _cart = [];
  final List<VyntaProduct> _favorites = [];
  final List<VyntaProduct> _publications = [];

  // ------- Sesión -------

  int? userId;
  String? userName;
  String? userEmail;

  bool get isLoggedIn => userId != null;

  void setSession(int id, String nombre, String email) {
    userId = id;
    userName = nombre;
    userEmail = email;
    notifyListeners();
  }

  void logout() {
    userId = null;
    userName = null;
    userEmail = null;
    _cart.clear();
    _favorites.clear();
    _publications.clear();
    notifyListeners();
  }

  // ------- Catálogo -------

  int catalogVersion = 0;

  void notifyCatalogChanged() {
    catalogVersion++;
    notifyListeners();
  }

  // ------- Comparación de productos -------

  bool _same(VyntaProduct a, VyntaProduct b) =>
      a.id != null && b.id != null ? a.id == b.id : a.name == b.name;

  // ------- Carrito -------

  List<CartItem> get cart => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  String get cartSubtotal {
    final total = _cart.fold<int>(
      0,
      (sum, item) => sum + _priceToInt(item.product.price) * item.quantity,
    );
    return _formatPrice(total);
  }

  void addToCart(VyntaProduct p) {
    final existing = _cart.where((i) => _same(i.product, p)).firstOrNull;
    if (existing != null) {
      existing.quantity++;
    } else {
      _cart.add(CartItem(p, 1));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void increaseQty(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cart.remove(item);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ------- Favoritos -------

  List<VyntaProduct> get favorites => List.unmodifiable(_favorites);
  int get favoritesCount => _favorites.length;

  bool isFavorite(VyntaProduct p) => _favorites.any((f) => _same(f, p));

  void toggleFavorite(VyntaProduct p) {
    final eraFavorito = isFavorite(p);
    if (eraFavorito) {
      _favorites.removeWhere((f) => _same(f, p));
    } else {
      _favorites.add(p);
    }
    notifyListeners();
    _syncFavorite(p, agregar: !eraFavorito);
  }

  Future<void> _syncFavorite(VyntaProduct p, {required bool agregar}) async {
    final productoId = _productId(p);
    if (userId == null || productoId == null) return;
    try {
      if (agregar) {
        await ApiClient.post('/api/favoritos', {
          'compradorId': userId,
          'productoId': productoId,
        });
      } else {
        await ApiClient.delete(
            '/api/favoritos?compradorId=$userId&productoId=$productoId');
      }
    } catch (e) {
      debugPrint('No se pudo sincronizar el favorito: $e');
    }
  }

  int? _productId(VyntaProduct p) => p.id;

  Future<void> loadFavorites() async {
    final id = userId;
    if (id == null) return;
    try {
      final favs =
          await ApiClient.get('/api/favoritos/comprador/$id') as List<dynamic>;
      final loaded = <VyntaProduct>[];
      for (final f in favs) {
        final productoId =
            ((f as Map<String, dynamic>)['productoId'] as num).toInt();
        final p = await ApiClient.get('/api/productos/$productoId')
            as Map<String, dynamic>;
        loaded.add(VyntaProduct.fromJson(p));
      }
      _favorites
        ..clear()
        ..addAll(loaded);
      notifyListeners();
    } catch (e) {
      debugPrint('No se pudieron cargar los favoritos: $e');
    }
  }

  // ------- Publicaciones -------

  List<VyntaProduct> get publications => List.unmodifiable(_publications);
  int get publicationsCount => _publications.length;

  void publishProduct(VyntaProduct p) {
    _publications.add(p);
    notifyListeners();
  }

  // ------- Helpers de precio -------

  int priceToInt(String price) {
    final digits = price.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String formatPrice(int amount) => _formatPrice(amount);

  int _priceToInt(String price) {
    return priceToInt(price);
  }

  String _formatPrice(int amount) {
    final s = amount.toString();
    final sb = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        sb.write('.');
      }
      sb.write(s[i]);
    }
    return '\$ $sb';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    for (final e in this) {
      return e;
    }
    return null;
  }
}