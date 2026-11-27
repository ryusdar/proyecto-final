import 'package:flutter/material.dart';
import 'checkout_confirmation_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../core/text_size_manager.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

// Pantalla donde revisa elpedido
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Lista de métodos de pago disponibles.
  final List<_PaymentMethod> _methods = const [
    _PaymentMethod(
      Icons.credit_card,
      'Tarjeta de crédito',
      'Visa · Mastercard · Amex',
      'TARJETA_CREDITO',
    ),
    _PaymentMethod(
      Icons.account_balance,
      'Transferencia bancaria',
      'CBU / CVU',
      'TRANSFERENCIA',
    ),
  ];

  //método de pago seleccionado.
  int _selectedMethod = 0;

  bool _loading = false;

  /// mensajes al usuario mediante un SnackBar.
  void _showMessage(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    // Obtener las preferencias de accesibilidad.
    final accessibility = AccessibilityScope.of(context);

    //cambios realizados en el carrito.
    return ListenableBuilder(
      listenable: VyntaStore.instance,
      builder: (context, _) {
        final store = VyntaStore.instance;
        final cart = store.cart;

        //colores según el tema seleccionado.
        final backgroundColor = AccessibilityColors.background(context);

        final textColor = AccessibilityColors.text(context);

        // tamaño de texto seleccionado.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextSizeManager.getTextScaler(accessibility.fontScale),
          ),

          child: Scaffold(
            backgroundColor: backgroundColor,

            body: AppFrame(
              color: backgroundColor,

              //el carrito está vacío se mostrar un mensaje sino mostrar el proceso de compra.
              child: cart.isEmpty
                  ? Center(
                      child: Text(
                        'Tu carrito está vacío',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                              const Expanded(
                                child: Text(
                                  "Finalizar compra",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: VyntaColors.cardWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // se mueve cuando hay muchos productos con el tamaño de texto grande.
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Resumen del pedido",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // TARJETA CON LOS PRODUCTOS Y SUS PRECIOS.
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: VyntaColors.cardWhite,
                                    borderRadius: BorderRadius.circular(
                                      VyntaColors.radius,
                                    ),
                                  ),

                                  child: Column(
                                    children: [
                                      // Recorrer todos los productos en el carrito.
                                      ...cart.map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),

                                          child: Row(
                                            children: [
                                              // Cantidad y nombre del producto.
                                              Expanded(
                                                child: Text(
                                                  '${item.quantity}× ${item.product.name}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: VyntaColors.ink,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              // Importe de cantidad de ese producto.
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

                                      // TOTAL DE LA COMPRA.
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

                                Text(
                                  "Método de pago",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // tarjeta por cada método de pago
                                ...List.generate(
                                  _methods.length,
                                  (i) => _paymentTile(i),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // PIE DE PÁGINA.
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: BuildFooter(color: Colors.black45),
                        ),

                        // BOTÓN PARA CONFIRMAR Y PAGAR
                        Container(
                          width: double.infinity,
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

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: VyntaColors.accentTurquoise,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    VyntaColors.radius,
                                  ),
                                ),
                              ),

                              // no se puede enviar otra solicitud cuando se está procesando la compra.
                              onPressed: _loading
                                  ? null
                                  : () => _confirmPurchase(store),

                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: VyntaColors.ink,
                                      ),
                                    )
                                  // Mostrar el texto y el icono de seguridad.
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.lock_outline,
                                            color: VyntaColors.ink,
                                            size: 20,
                                          ),

                                          const SizedBox(width: 8),

                                          Text(
                                            'Confirmar y pagar ${store.cartSubtotal}',
                                            style: const TextStyle(
                                              color: VyntaColors.ink,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
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

  /// Permite seleccionar una opción antes de confirmar la compra.
  Widget _paymentTile(int index) {
    final method = _methods[index];

    final selected = index == _selectedMethod;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = index;
        });
      },

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

  /// Calcula el precio del pedido.
  String _lineTotal(CartItem item) {
    final store = VyntaStore.instance;

    final price = store.priceToInt(item.product.price);

    return store.formatPrice(price * item.quantity);
  }

  /// Busca en el backend el identificador del tipo de pago y el código seleccionado.
  Future<int> _paymentTypeId(String codigo) async {
    final data = await ApiClient.get('/api/tipos-pago') as List<dynamic>;

    for (final t in data) {
      final m = t as Map<String, dynamic>;

      if (m['codigo'] == codigo) {
        return (m['id'] as num).toInt();
      }
    }

    // Si no existe el método, informar el error
    throw ApiException(
      'El tipo de pago "$codigo" no está cargado en el servidor',
    );
  }

  /// Procesa la compra y envía el pedido al backend
  Future<void> _confirmPurchase(VyntaStore store) async {
    final userId = store.userId;

    if (userId == null) {
      _showMessage('Iniciá sesión para comprar');
      return;
    }

    final items = List<CartItem>.from(store.cart);

    // Comprobar que todos los productos tengan un identificador válido
    if (items.any((i) => i.product.id == null)) {
      _showMessage(
        'El carrito tiene productos de ejemplo que no se pueden comprar. Quitalos e intentá de nuevo.',
      );
      return;
    }

    // Guardar el total y el método antes de limpiar el carrito.
    final paid = store.cartSubtotal;
    final method = _methods[_selectedMethod];

    setState(() {
      _loading = true;
    });

    try {
      final tipoPagoId = await _paymentTypeId(method.code);

      // Crear el pedido y enviar el identificador del compradory el tipo de pago seleccionado
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

      // Mostrar la pantalla de confirmación de compra.
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
      // Mostrar un mensajesi falla la solicitud
      _showMessage(
        e.statusCode == 500
            ? 'No se pudo crear el pedido. Revisá que los productos sigan disponibles.'
            : e.message,
      );
    } catch (_) {
      _showMessage('No se pudo completar la compra');
    } finally {
      // Finalizar la carga si la pantalla continúa activa
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}

/// método de pago
class _PaymentMethod {
  final IconData icon;
  final String name;
  final String subtitle;
  final String code;

  const _PaymentMethod(this.icon, this.name, this.subtitle, this.code);
}
