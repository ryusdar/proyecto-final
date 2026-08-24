import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'publish_success_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
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

  String _selectedCategory = 'Hogar';
  IconData _selectedIcon = Icons.weekend;
  final _formKey = GlobalKey<FormState>();

  static const Map<String, IconData> _categories = {
    'Hogar': Icons.chair,
    'Tecnología': Icons.laptop_mac,
    'Herramientas': Icons.handyman,
    'Manualidades': Icons.palette,
    'Decoración': Icons.light_mode,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();
    // Formatea el precio
    final numeric =
        int.tryParse(priceText.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final price = VyntaStore.instance.formatPrice(numeric);

    final store = VyntaStore.instance;
    store.publishProduct(VyntaProduct(name, price, _selectedIcon));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublishSuccessScreen(name: name, price: price),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "Publicar producto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.cardWhite,
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
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          dropdownColor: VyntaColors.cardWhite,
                          decoration: _fieldDecoration(Icons.category_outlined),
                          items: _categories.keys
                              .map(
                                (key) => DropdownMenuItem(
                                  value: key,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _categories[key],
                                        size: 18,
                                        color: VyntaColors.brandPurple,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        key,
                                        style: const TextStyle(
                                          color: VyntaColors.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _selectedCategory = v;
                                _selectedIcon = _categories[v]!;
                              });
                            }
                          },
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

              // Botón publicar
              Container(
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
                    onPressed: _submit,
                    icon: const Icon(
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
