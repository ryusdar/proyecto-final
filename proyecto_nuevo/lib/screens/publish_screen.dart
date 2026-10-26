import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'publish_success_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

/// Formulario de publicación de un producto artesanal.

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  List<VyntaCategory> _cats = [];
  VyntaCategory? _selected;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _loadCategories() async {
    try {
      final data = await ApiClient.get('/api/categorias') as List<dynamic>;
      final cats = data
          .map((e) => VyntaCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        _cats = cats;
        _selected = cats.isNotEmpty ? cats.first : null;
      });
    } catch (e) {
      _showMessage('No se pudieron cargar las categorías');
    }
  }

  /// Si el usuario todavía no es vendedor, lo convierte.
  Future<void> _ensureSeller(int userId) async {
    try {
      await ApiClient.get('/api/vendedores/$userId');
    } on ApiException {
      // No existe: lo creamos con una tienda por defecto
      final nombre = VyntaStore.instance.userName ?? 'Mi tienda';
      await ApiClient.post('/api/vendedores', {
        'usuarioId': userId,
        'nombreTienda': 'Tienda de $nombre',
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final store = VyntaStore.instance;
    final userId = store.userId;
    if (userId == null) {
      _showMessage('Iniciá sesión para publicar');
      return;
    }

    final cat = _selected;
    if (cat == null || cat.id == null) {
      _showMessage('Elegí una categoría');
      return;
    }

    final name = _nameController.text.trim();
    final numeric =
        int.tryParse(_priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
            0;
    final price = store.formatPrice(numeric);

    setState(() => _loading = true);
    try {
      await _ensureSeller(userId);

      final r = await ApiClient.post('/api/productos', {
        'vendedorId': userId,
        'categoriaId': cat.id,
        'nombre': name,
        'descripcion': _descController.text.trim(),
        'precio': numeric,
        'stock': 1,
      });

      store.publishProduct(
        VyntaProduct(
          name,
          price,
          cat.icon,
          id: (r['id'] as num).toInt(),
        ),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PublishSuccessScreen(name: name, price: price),
        ),
      );
    } on ApiException catch (e) {
      _showMessage(
        e.statusCode == 500
            ? 'No se pudo publicar. Revisá que la categoría exista.'
            : e.message,
      );
    } catch (_) {
      _showMessage('No se pudo publicar el producto');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de artesano
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(4, 8, 18, 14),
              color: VyntaColors.brandPurple,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: VyntaColors.cardWhite,
                    ),
                  ),
                  const Icon(
                    Icons.add_business,
                    color: VyntaColors.cardWhite,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Publicar producto",
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

            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: VyntaColors.cardWhite,
                            borderRadius: BorderRadius.circular(
                              VyntaColors.radius,
                            ),
                            border: Border.all(
                              color: VyntaColors.brandPurple,
                              width: 2,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: VyntaColors.brandPurple,
                                size: 32,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Foto del producto",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: VyntaColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nombre
                      const Text(
                        "Nombre del producto",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _field(
                        controller: _nameController,
                        hint: "Ej: Florero de cerámica",
                        icon: Icons.sell_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Ingresá un nombre"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Categoría
                      const Text(
                        "Categoría",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<VyntaCategory>(
                        key: ValueKey(_cats.length),
                        isExpanded: true,
                        initialValue: _selected,
                        dropdownColor: VyntaColors.cardWhite,
                        decoration: _fieldDecoration(Icons.category_outlined),
                        items: _cats
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Row(
                                  children: [
                                    Icon(
                                      c.icon,
                                      size: 18,
                                      color: VyntaColors.brandPurple,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        c.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: VyntaColors.ink,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selected = v),
                      ),
                      const SizedBox(height: 16),

                      // Precio
                      const Text(
                        "Precio",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _field(
                        controller: _priceController,
                        hint: "Ej: 12000",
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final n = int.tryParse(
                            (v ?? '').replaceAll(RegExp(r'[^\d]'), ''),
                          );
                          return (n == null || n <= 0)
                              ? "Ingresá un precio válido"
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      const Text(
                        "Descripción",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: VyntaColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        maxLength: 300,
                        decoration: InputDecoration(
                          hintText: "Contá sobre tu obra, materiales…",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: VyntaColors.cardWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              VyntaColors.radius,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: BuildFooter(color: Colors.black45),
            ),

            // Botón publicar (fijo abajo)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: VyntaColors.cardWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VyntaColors.accentTurquoise,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(VyntaColors.radius),
                    ),
                  ),
                  onPressed: _loading ? null : _submit,
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
                          Icons.cloud_upload_outlined,
                          color: VyntaColors.ink,
                          size: 20,
                        ),
                  label: const Text(
                    "Publicar",
                    style: TextStyle(
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
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        prefixIcon: Icon(icon, color: VyntaColors.brandPurple),
        filled: true,
        fillColor: VyntaColors.cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VyntaColors.radius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  InputDecoration _fieldDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: VyntaColors.brandPurple),
      filled: true,
      fillColor: VyntaColors.cardWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VyntaColors.radius),
        borderSide: BorderSide.none,
      ),
    );
  }
}