import 'package:flutter/material.dart';
import 'main_shell.dart';
import 'register_screen.dart';
import '../widgets/vynta_logo.dart';
import '../widgets/build_footer.dart';
import '../core/vynta_colors.dart';
import '../core/api_client.dart';
import '../core/vynta_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Completá el correo y la contraseña');
      return;
    }

    setState(() => _loading = true);
    try {
      final r = await ApiClient.post('/api/auth/login', {
        'email': email,
        'password': password,
      });

      VyntaStore.instance.setSession(
        (r['id'] as num).toInt(),
        r['nombre'] as String,
        r['email'] as String,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } on ApiException catch (e) {
      // El backend responde 500 cuando las credenciales no coinciden
      final msg = (e.statusCode == 500 || e.statusCode == 400)
          ? 'Correo o contraseña incorrectos'
          : e.message;
      _showMessage(msg);
    } catch (_) {
      _showMessage('No se pudo iniciar sesión');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                  const SizedBox(height: 30),
                  Center(child: VyntaLogo(width: 150)),
                  const SizedBox(height: 50),
                  const Text(
                    "BIENVENIDOS DE NUEVO",
                    style: TextStyle(
                      color: VyntaColors.cardWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    "Iniciá sesión para seguir comprando",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 30),

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

                  const SizedBox(height: 22),

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
                    onSubmitted: (_) => _loading ? null : _login(),
                    style: const TextStyle(color: VyntaColors.cardWhite),
                    decoration: _inputDecoration('••••••••', Icons.lock_outline)
                        .copyWith(
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

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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
                      onPressed: _loading ? null : _login,
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
                              "Iniciar sesión",
                              style: TextStyle(
                                color: VyntaColors.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Toda la fila es un área clickeable con cursor pointer.
                  Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "¿No tenés cuenta?",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Regístrate",
                                style: TextStyle(
                                  color: VyntaColors.cardWhite,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: VyntaColors.cardWhite,
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 24),
                  const Center(child: BuildFooter()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}