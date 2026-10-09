import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../widgets/build_footer.dart';

class CartScreen extends StatelessWidget {
  /// Si es falso no muestra el botón de volver.
  final bool showBack;
  const CartScreen({super.key, this.showBack = true});

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 72,
            color: VyntaColors.contentGrey,
          ),
          SizedBox(height: 16),
          Text(
            "Tu carrito está vacío",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: VyntaColors.ink,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Agregá productos desde el detalle\npara empezar tu compra.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: VyntaStore.instance,
      builder: (context, _) {
        final store = VyntaStore.instance;
        final cart = store.cart;

        return Scaffold(
          backgroundColor: VyntaColors.contentGrey,
          body: Center(
            child: Container(
              width: 390,
              height: double.infinity,
              color: VyntaColors.contentGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con contador
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
                    color: VyntaColors.navTeal,
                    child: Row(
                      children: [
                        // Botón volver
                        if (showBack)
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: VyntaColors.cardWhite,
                            ),
                          ),
                        const Icon(
                          Icons.shopping_cart,
                          color: VyntaColors.cardWhite,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mi carrito (${store.cartCount})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: VyntaColors.cardWhite,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Items o vacío
                  Expanded(
                    child: cart.isEmpty
                        ? _emptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(14),
                            itemCount: cart.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                _cartItem(context, store, cart[i]),
                          ),
                  ),

                  // Resumen + pagar
                  if (cart.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: VyntaColors.cardWhite,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                store.cartSubtotal,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: VyntaColors.ink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: VyntaColors.accentTurquoise,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    VyntaColors.radius,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Ir al checkout para finalizar la compra.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckoutScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Pagar ${store.cartSubtotal}',
                                style: const TextStyle(
                                  color: VyntaColors.ink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
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
      },
    );
  }

  Widget _cartItem(BuildContext context, VyntaStore store, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: VyntaColors.cardWhite,
        borderRadius: BorderRadius.circular(VyntaColors.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: VyntaColors.contentGrey,
              borderRadius: BorderRadius.circular(VyntaColors.radiusSmall),
            ),
            child: Icon(
              item.product.icon,
              size: 32,
              color: VyntaColors.brandPurple,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: VyntaColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: VyntaColors.brandPurple,
                  ),
                ),
              ],
            ),
          ),
          // Contador + quitar
          Column(
            children: [
              Row(
                children: [
                  _qtyBtn(Icons.remove, () => store.decreaseQty(item)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.ink,
                      ),
                    ),
                  ),
                  _qtyBtn(Icons.add, () => store.increaseQty(item)),
                ],
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () => store.removeFromCart(item),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "Quitar",
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: VyntaColors.contentGrey,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: VyntaColors.ink),
      ),
    );
  }
}
