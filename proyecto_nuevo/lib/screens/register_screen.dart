import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../widgets/vynta_logo.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/vynta_store.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: VyntaColors.cardWhite),
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

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _register() async {
    final nombre = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
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
      final r = await ApiClient.post('/api/auth/registro', {
        'nombre': nombre,
        'email': email,
        'password': password,
      });

      VyntaStore.instance.setSession(
        (r['id'] as num).toInt(),
        r['nombre'] as String,
        r['email'] as String,
      );

      if (!mounted) return;
      // Reemplaza todo el stack para que "volver" no regrese al registro/login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
        (route) => false,
      );
    } on ApiException catch (e) {
      // El backend responde 500 si el email ya está registrado
      final msg = e.statusCode == 500
          ? 'No se pudo registrar. ¿El correo ya está en uso?'
          : e.message;
      _showMessage(msg);
    } catch (_) {
      _showMessage('No se pudo registrar');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.brandPurple,
      body: Center(
        child: Container(
          width: 390,
          height: double.infinity,
          color: VyntaColors.brandPurple,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón volver
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

                  const Text(
                    "Crear cuenta",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Unite a Vynta y mostrá tus creaciones",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 26),

                  const Text(
                    "Nombre",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: VyntaColors.cardWhite),
                    decoration: _inputDecoration(
                      'Tu nombre',
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Correo electrónico",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: VyntaColors.cardWhite),
                    decoration: _inputDecoration(
                      'usuario@email.com',
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Contraseña",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: VyntaColors.cardWhite),
                    decoration:
                        _inputDecoration(
                          'Mínimo 8 caracteres',
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: VyntaColors.cardWhite,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Confirmar contraseña",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    onSubmitted: (_) => _loading ? null : _register(),
                    style: const TextStyle(color: VyntaColors.cardWhite),
                    decoration:
                        _inputDecoration(
                          'Repetí tu contraseña',
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: VyntaColors.cardWhite,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                  ),

                  const SizedBox(height: 30),

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
                          : const Text(
                              "Registrarme",
                              style: TextStyle(
                                color: VyntaColors.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿Ya tenés cuenta?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: VyntaColors.cardWhite,
                              fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
}