import 'package:flutter/material.dart';

void main() {
  runApp(const VyntaApp());
}

class VyntaApp extends StatelessWidget {
  const VyntaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 360,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF7B35F2),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                children: [
                  const SizedBox(height: 45),

                  // Acá después pueden poner el logo real con Image.asset
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 90,
                    color: Colors.cyanAccent,
                  ),

                  const Text(
                    "Vynta",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),

                  const SizedBox(height: 65),

                  const Text(
                    "BIENVENIDOS DE NUEVO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 35),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Correo electronico",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      suffixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contraseña",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      suffixIcon: const Icon(Icons.visibility_off_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: Colors.black),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28C7B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "¿No tienes cuenta? Regístrate",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
