import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'publish_success_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/api_client.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  // Controladores para recuperar lo que escribe el usuario
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  // Clave para validar los campos del formulario
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Categorias obtenidas desde el backend
  List<VyntaCategory> _cats = [];
  VyntaCategory? _selected;

  @override
  void initState() {
    super.initState();

    _loadCategories();
  }

  @override
  void dispose() {
    // Liberamos los controladores cuando se cierra la pantalla
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();

    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;

    final fontScale = AccessibilityScope.of(context).fontScale;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(fontSize: 14 * fontScale)),
      ),
    );
  }

  // Convierte a minusculas elimina tildes y espacios sobrantes
  String _normalize(String s) {
    const from = 'áàäâéèëêíìïîóòöôúùüûñ';
    const to = 'aaaaeeeeiiiioooouuuun';

    var out = s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    for (var i = 0; i < from.length; i++) {
      out = out.replaceAll(from[i], to[i]);
    }

    return out;
  }

  // Se obtienen las categorías disponibles desde la API
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

  // Permite crear una categoria nueva
  Future<void> _addCategory() async {
    final fontScale = AccessibilityScope.of(context).fontScale;
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Nueva categoría',
          style: TextStyle(fontSize: 18 * fontScale),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 50,
          style: TextStyle(fontSize: 14 * fontScale),
          decoration: InputDecoration(
            hintText: 'Ej: Cerámica',
            hintStyle: TextStyle(fontSize: 14 * fontScale),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: TextStyle(fontSize: 14 * fontScale)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Crear', style: TextStyle(fontSize: 14 * fontScale)),
          ),
        ],
      ),
    );

    controller.dispose();

    if (name == null || name.isEmpty) return;

    final existing = _cats
        .where((c) => _normalize(c.name) == _normalize(name))
        .firstOrNull;

    if (existing != null) {
      setState(() => _selected = existing);
      _showMessage('La categoría "${existing.name}" ya existe');
      return;
    }

    try {
      final r =
          await ApiClient.post('/api/categorias', {'nombre': name})
              as Map<String, dynamic>;

      final created = VyntaCategory.fromJson(r);

      if (!mounted) return;

      setState(() {
        _cats = [..._cats, created];
        _selected = created;
      });

      // cambios el catalogo de productos y categorias
      VyntaStore.instance.notifyCatalogChanged();

      _showMessage('Categoría "$name" creada');
    } on ApiException catch (e) {
      _showMessage(e.statusCode == 500 ? 'Esa categoría ya existe' : e.message);

      await _loadCategories();
    } catch (_) {
      _showMessage('No se pudo crear la categoría');
    }
  }

  // Se revisa si el usuario ya tiene un perfil de vendedor.
  Future<void> _ensureSeller(int userId) async {
    try {
      await ApiClient.get('/api/vendedores/$userId');
    } on ApiException {
      final nombre = VyntaStore.instance.userName ?? 'Mi tienda';

      await ApiClient.post('/api/vendedores', {
        'usuarioId': userId,
        'nombreTienda': 'Tienda de $nombre',
      });
    }
  }

  // Valida los datos y publica el producto en el backend
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

    // se convierte el precio ingresado a un número entero
    final numeric =
        int.tryParse(_priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
        0;

    final price = store.formatPrice(numeric);

    setState(() => _loading = true);

    try {
      // verifica si existe el perfil del vendedor
      await _ensureSeller(userId);

      final r = await ApiClient.post('/api/productos', {
        'vendedorId': userId,
        'categoriaId': cat.id,
        'nombre': name,
        'descripcion': _descController.text.trim(),
        'precio': numeric,
        'stock': 1,
      });

      // se guarda producto para mostrar en el catalogo
      store.publishProduct(
        VyntaProduct(name, price, cat.icon, id: (r['id'] as num).toInt()),
      );

      store.notifyCatalogChanged();

      if (!mounted) return;

      //pantalla de publicación exitosa
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
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // preferencias de accesibilidad
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    // El fondo y los textos se adaptan al tema elegido
    final backgroundColor = AccessibilityColors.background(context);
    final textColor = AccessibilityColors.text(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AppFrame(
        color: backgroundColor,
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                  Expanded(
                    child: Text(
                      "Publicar producto",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.bold,
                        color: VyntaColors.cardWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Formulario con desplazamiento vertical
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Espacio destinado a la foto del producto
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo,
                                color: VyntaColors.brandPurple,
                                size: 32,
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Foto del producto",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12 * fontScale,
                                  color: VyntaColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Nombre del producto",
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _field(
                        controller: _nameController,
                        hint: "Ej: Florero de cerámica",
                        icon: Icons.sell_outlined,
                        fontScale: fontScale,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "Ingresá un nombre"
                            : null,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Categoría",
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<VyntaCategory>(
                        key: ValueKey('${_cats.length}-${_selected?.id}'),
                        isExpanded: true,
                        initialValue: _selected,
                        dropdownColor: VyntaColors.cardWhite,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: VyntaColors.ink,
                        ),
                        decoration: _fieldDecoration(Icons.category_outlined),
                        items: _cats.map((c) {
                          return DropdownMenuItem(
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
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      color: VyntaColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() => _selected = v);
                        },
                      ),

                      // Se agrega una categoria nueva
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addCategory,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            'Nueva categoría',
                            style: TextStyle(fontSize: 14 * fontScale),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Precio",
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _field(
                        controller: _priceController,
                        hint: "Ej: 12000",
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                        fontScale: fontScale,
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

                      Text(
                        "Descripción",
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        maxLength: 300,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: VyntaColors.ink,
                        ),
                        decoration: InputDecoration(
                          hintText: "Contá sobre tu obra, materiales…",
                          hintStyle: TextStyle(
                            fontSize: 14 * fontScale,
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

            // Pie de pagina
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: BuildFooter(color: Colors.black45),
            ),

            // boton para publicar
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

                  // Texto del boton con tamaño adaptable
                  label: Text(
                    "Publicar",
                    style: TextStyle(
                      color: VyntaColors.ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * fontScale,
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

  // campos de texto reutilizables del formulario
  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double fontScale,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,

      // Tamaño de letra adaptable de la  accesibilidad
      style: TextStyle(fontSize: 14 * fontScale, color: VyntaColors.ink),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14 * fontScale, color: Colors.grey),
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
