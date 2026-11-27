import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../widgets/app_frame.dart';
import '../widgets/vynta_logo.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/vynta_store.dart';
import '../core/accessibility_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // para recuperar los datos ingresados
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  // Permiten mostrar u ocultar las contraseñas
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // muestra si se está realizando el registro
  bool _loading = false;

  @override
  void dispose() {
    //controladores para errar la pantalla
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  // El tamaño de las etiquetas cambia segun la accesibilidad
  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    double fontScale,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: VyntaColors.cardWhite,
        fontSize: 14 * fontScale,
      ),
      prefixIcon: Icon(icon, color: VyntaColors.cardWhite),
      filled: true,
      fillColor: VyntaColors.cardWhite.withValues(alpha: 0.18),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: VyntaColors.internalPadding,
        vertical: VyntaColors.internalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VyntaColors.radius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VyntaColors.radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(VyntaColors.radius),
        borderSide: const BorderSide(
          color: VyntaColors.accentTurquoise,
          width: 2,
        ),
      ),
    );
  }

  // mensajes de validacion o errores
  void _showMessage(String text) {
    if (!mounted) return;

    final fontScale = AccessibilityScope.of(context).fontScale;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(fontSize: 14 * fontScale)),
      ),
    );
  }

  // Registra un usuario en el backend
  Future<void> _register() async {
    final nombre = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // Valida los campos obligatorios
    if (nombre.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showMessage('Completá todos los campos');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('El correo no es válido');
      return;
    }

    if (password.length < 8) {
      _showMessage('La contraseña debe tener al menos 8 caracteres');
      return;
    }

    if (password != confirm) {
      _showMessage('Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);

    try {
      // Seenvian los datos al endpoint del registro
      final r = await ApiClient.post('/api/auth/registro', {
        'nombre': nombre,
        'email': email,
        'password': password,
      });

      // Guardamos la sesión del usuario
      VyntaStore.instance.setSession(
        (r['id'] as num).toInt(),
        r['nombre'] as String,
        r['email'] as String,
      );

      if (!mounted) return;

      // se elimina las pantallas anteriores
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
        (route) => false,
      );
    } on ApiException catch (e) {
      final msg = e.statusCode == 500
          ? 'No se pudo registrar. ¿El correo ya está en uso?'
          : e.message;

      _showMessage(msg);
    } catch (_) {
      _showMessage('No se pudo registrar');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // se reestablece el tamaño de texto antes de la accesibilidad.
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    return Scaffold(
      backgroundColor: VyntaColors.brandPurple,
      body: AppFrame(
        color: VyntaColors.brandPurple,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // se reduce los margenes en pantallas chicas
              final hPad = constraints.maxWidth < 360 ? 24.0 : 38.0;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Boton para regresar al inicio
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: VyntaColors.cardWhite,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Center(child: VyntaLogo(width: 120)),

                      const SizedBox(height: 24),

                      // Titulo principal
                      Text(
                        "Crear cuenta",
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 20 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Unite a Vynta y mostrá tus creaciones",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13 * fontScale,
                        ),
                      ),

                      const SizedBox(height: 26),

                      Text(
                        "Nombre",
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                        ),
                        decoration: _inputDecoration(
                          'Tu nombre',
                          Icons.person_outline,
                          fontScale,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Correo electrónico",
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                        ),
                        decoration: _inputDecoration(
                          'usuario@email.com',
                          Icons.email_outlined,
                          fontScale,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Contraseña",
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                        ),
                        decoration:
                            _inputDecoration(
                              'Mínimo 8 caracteres',
                              Icons.lock_outline,
                              fontScale,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: VyntaColors.cardWhite,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Confirmar contraseña",
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Campo para repetir la contraseña
                      TextField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        onSubmitted: (_) {
                          if (!_loading) {
                            _register();
                          }
                        },
                        style: TextStyle(
                          color: VyntaColors.cardWhite,
                          fontSize: 14 * fontScale,
                        ),
                        decoration:
                            _inputDecoration(
                              'Repetí tu contraseña',
                              Icons.lock_outline,
                              fontScale,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: VyntaColors.cardWhite,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  });
                                },
                              ),
                            ),
                      ),

                      const SizedBox(height: 30),

                      // Boton para enviar el formulario de registro
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            backgroundColor: VyntaColors.accentTurquoise,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                VyntaColors.radius,
                              ),
                            ),
                          ),

                          onPressed: _loading ? null : _register,

                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: VyntaColors.ink,
                                  ),
                                )
                              : Text(
                                  "Registrarme",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: VyntaColors.ink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15 * fontScale,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Acceso para quienes ya tienen una cuenta
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "¿Ya tenés cuenta?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14 * fontScale,
                              ),
                            ),

                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  color: VyntaColors.cardWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14 * fontScale,
                                  decoration: TextDecoration.underline,
                                  decorationColor: VyntaColors.cardWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
