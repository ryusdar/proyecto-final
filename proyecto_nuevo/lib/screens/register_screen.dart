import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/vynta_logo.dart';
import '../core/vynta_colors.dart';

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

  void _register() {
    // solo navega al Home tras "registrarse".

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                          'Mínimo 6 caracteres',
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
                      onPressed: _register,
                      child: const Text(
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
