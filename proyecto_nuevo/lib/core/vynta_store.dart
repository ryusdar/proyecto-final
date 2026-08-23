import 'package:flutter/foundation.dart';
import '../screens/home_screen.dart';

/// Ítem de carrito: producto + cantidad.
class CartItem {
  final VyntaProduct product;
  int quantity;
  CartItem(this.product, this.quantity);
}

/// Estado global de la app (mock, sin backend).
/// Carrito y favoritos vividos en memoria mientras dura la sesión.
/// Es un ChangeNotifier para que las pantallas reaccionen a los cambios
/// (Listener / ListenableBuilder), sin necesidad de agregar paquetes.
class VyntaStore extends ChangeNotifier {
  VyntaStore._();
  static final VyntaStore instance = VyntaStore._();

  final List<CartItem> _cart = [];
  final List<VyntaProduct> _favorites = [];
  final List<VyntaProduct> _publications = [];

  // ------- Carrito -------

  List<CartItem> get cart => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal en texto (moneda simulada).
  String get cartSubtotal {
    final total = _cart.fold<int>(
      0,
      (sum, item) => sum + _priceToInt(item.product.price) * item.quantity,
    );
    return _formatPrice(total);
  }

  void addToCart(VyntaProduct p) {
    final existing = _cart.where((i) => i.product.name == p.name).firstOrNull;
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

  bool isFavorite(VyntaProduct p) => _favorites.any((f) => f.name == p.name);

  void toggleFavorite(VyntaProduct p) {
    if (isFavorite(p)) {
      _favorites.removeWhere((f) => f.name == p.name);
    } else {
      _favorites.add(p);
    }
    notifyListeners();
  }

  // ------- Publicaciones (lado artesano) -------

  List<VyntaProduct> get publications => List.unmodifiable(_publications);
  int get publicationsCount => _publications.length;

  /// Registra un producto publicado por el artesano (mock, en memoria).
  void publishProduct(VyntaProduct p) {
    _publications.add(p);
    notifyListeners();
  }

  // ------- Helpers de precio (dato mock "$ 8.500" -> int) -------

  /// Convierte un precio en texto ("$ 8.500") a un int (8500).
  int priceToInt(String price) {
    final digits = price.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(digits) ?? 0;
  }

  /// Formatea un entero a la moneda simulada de la app ("$ 12.500").
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
