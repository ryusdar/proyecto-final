import 'package:flutter/material.dart';
import 'checkout_confirmation_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../widgets/build_footer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<_PaymentMethod> _methods = const [
    _PaymentMethod(
      Icons.credit_card,
      'Tarjeta de crédito',
      'Visa · Masercard · Amex',
      'TARJETA_CREDITO',
    ),

    _PaymentMethod(
      Icons.account_balance,
      'Transferencia bancaria',
      'CBU / CVU',
      'TRANSFERENCIA',
    ),
  ];

  int _selectedMethod = 0;
  bool _loading = false;

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: VyntaStore.instance,
      builder: (context, _) {
        final store = VyntaStore.instance;
        final cart = store.cart;

        // Si el carrito está vacío no mostrar checkout.
        if (cart.isEmpty) {
          return Scaffold(
            backgroundColor: VyntaColors.contentGrey,
            body: const Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(color: VyntaColors.ink, fontSize: 16),
              ),
            ),
          );
        }

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
                  // Encabezado
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
                        const Text(
                          "Finalizar compra",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: VyntaColors.cardWhite,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contenido
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Resumen del pedido
                          const Text(
                            "Resumen del pedido",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: VyntaColors.cardWhite,
                              borderRadius: BorderRadius.circular(
                                VyntaColors.radius,
                              ),
                            ),
                            child: Column(
                              children: [
                                ...cart.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${item.quantity}× ${item.product.name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: VyntaColors.ink,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _lineTotal(item),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: VyntaColors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: VyntaColors.ink,
                                      ),
                                    ),
                                    Text(
                                      store.cartSubtotal,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: VyntaColors.brandPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Métodos de pago
                          const Text(
                            "Método de pago",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VyntaColors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(
                            _methods.length,
                            (i) => _paymentTile(i),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: BuildFooter(color: Colors.black45),
                  ),

                  // Confirmar pago
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: VyntaColors.cardWhite,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VyntaColors.accentTurquoise,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              VyntaColors.radius,
                            ),
                          ),
                        ),
                        onPressed: _loading
                            ? null
                            : () => _confirmPurchase(store),
                        icon: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: VyntaColors.ink,
                                ),
                              )
                            : const Icon(
                                Icons.lock_outline,
                                color: VyntaColors.ink,
                                size: 20,
                              ),
                        label: Text(
                          'Confirmar y pagar ${store.cartSubtotal}',
                          style: const TextStyle(
                            color: VyntaColors.ink,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _paymentTile(int index) {
    final method = _methods[index];
    final selected = index == _selectedMethod;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: VyntaColors.cardWhite,
          borderRadius: BorderRadius.circular(VyntaColors.radius),
          border: Border.all(
            color: selected ? VyntaColors.accentTurquoise : Colors.transparent,
            width: 2,
          ),
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
            Icon(method.icon, color: VyntaColors.brandPurple, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: VyntaColors.ink,
                    ),
                  ),
                  Text(
                    method.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? VyntaColors.accentTurquoise : Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  String _lineTotal(CartItem item) {
    final store = VyntaStore.instance;
    final price = store.priceToInt(item.product.price);
    return store.formatPrice(price * item.quantity);
  }

  /// Busca en el backend el id del tipo de pago según su código.
  Future<int> _paymentTypeId(String codigo) async {
    final data = await ApiClient.get('/api/tipos-pago') as List<dynamic>;
    for (final t in data) {
      final m = t as Map<String, dynamic>;
      if (m['codigo'] == codigo) return (m['id'] as num).toInt();
    }
    throw ApiException('El tipo de pago "$codigo" no está cargado en el servidor');
  }

    Future<void> _confirmPurchase(VyntaStore store) async {
    final userId = store.userId;
    if (userId == null) {
      _showMessage('Iniciá sesión para comprar');
      return;
    }

    final items = List<CartItem>.from(store.cart);
    if (items.any((i) => i.product.id == null)) {
      _showMessage(
        'El carrito tiene productos de ejemplo que no se pueden comprar. Quitalos e intentá de nuevo.',
      );
      return;
    }

    // Guarda el total y el método antes de limpiar el carrito.
    final paid = store.cartSubtotal;
    final method = _methods[_selectedMethod];

    setState(() => _loading = true);
    try {
      final tipoPagoId = await _paymentTypeId(method.code);

      final pedido = await ApiClient.post('/api/pedidos', {
        'compradorId': userId,
        'tipoPagoId': tipoPagoId,
      });
      final pedidoId = (pedido['id'] as num).toInt();

      for (final item in items) {
        await ApiClient.post('/api/pedidos/$pedidoId/items', {
          'productoId': item.product.id,
          'cantidad': item.quantity,
        });
      }

      store.clearCart();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutConfirmationScreen(
            total: paid,
            method: method.name,
            orderId: pedidoId,
          ),
        ),
      );
    } on ApiException catch (e) {
      _showMessage(
        e.statusCode == 500
            ? 'No se pudo crear el pedido. Revisá que los productos sigan disponibles.'
            : e.message,
      );
    } catch (_) {
      _showMessage('No se pudo completar la compra');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _PaymentMethod {
  final IconData icon;
  final String name;
  final String subtitle;
  final String code; // código del tipo de pago en el backend
  const _PaymentMethod(this.icon, this.name, this.subtitle, this.code);
}