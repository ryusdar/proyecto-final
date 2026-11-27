import 'package:flutter/material.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../core/accessibility_colors.dart';
import '../core/accessibility_controller.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';
import 'accessibility_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  /// Si es false no muestra el boton de volver
  final bool showBack;

  const ProfileScreen({super.key, this.showBack = true});

  // Cierra la sesion del usuario y vuelve a la pantalla de inicio
  void _logout(BuildContext context) {
    VyntaStore.instance.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = VyntaStore.instance;

    // Se Recuperan los datos del usuario
    final name = store.userName ?? "Invitado";
    final email = store.userEmail ?? "";

    // configuración de accesibilidad
    final accessibility = AccessibilityScope.of(context);
    final fontScale = accessibility.fontScale;

    // Colores que cambian según el modo
    final backgroundColor = AccessibilityColors.background(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AppFrame(
        color: backgroundColor,
        maxWidth: 900,
        child: Column(
          children: [
            // Contenido principal de la pantalla
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeader(context, name, email, fontScale),

                    const SizedBox(height: 18),

                    _buildOptions(context, fontScale),
                  ],
                ),
              ),
            ),

            // Pie de pagina
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: BuildFooter(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  // Encabezado con la foto, nombre y correo del usuario
  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    double fontScale,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 230),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [VyntaColors.accentTurquoise, Color(0xFF63E6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Boton para volver a la pantalla anterior
          if (showBack)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: VyntaColors.ink),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          // Foto y datos del usuario
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: VyntaColors.brandPurple,
                      child: Icon(Icons.person, size: 54, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Texto con tamaño adaptable
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17 * fontScale,
                      color: VyntaColors.ink,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: VyntaColors.ink,
                      fontSize: 14 * fontScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Opciones disponibles dentro del perfil
  Widget _buildOptions(BuildContext context, double fontScale) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Acceso al panel para publicar artesanias
              _publishButton(fontScale),

              const SizedBox(height: 20),

              _SectionTitle("Mi cuenta", fontScale: fontScale),

              const SizedBox(height: 8),

              _Option(
                Icons.info_outline,
                "Información personal",
                fontScale: fontScale,
              ),

              // Navegacion hacia la pantalla de favoritos
              _Option(
                Icons.favorite_outline,
                "Favoritos",
                fontScale: fontScale,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),

              _Option(
                Icons.shopping_bag_outlined,
                "Compras",
                fontScale: fontScale,
              ),

              _Option(
                Icons.payment_outlined,
                "Métodos de pago",
                fontScale: fontScale,
              ),

              const SizedBox(height: 20),

              _SectionTitle("Más", fontScale: fontScale),

              const SizedBox(height: 8),

              _Option(
                Icons.settings_outlined,
                "Configuración",
                fontScale: fontScale,
              ),

              // Acceso a las opciones de accesibilidad
              _Option(
                Icons.accessibility_new,
                "Accesibilidad",
                fontScale: fontScale,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccessibilityScreen(),
                    ),
                  );
                },
              ),

              _Option(Icons.help_outline, "Ayuda", fontScale: fontScale),

              // Cerrar sesión.
              _Option(
                Icons.logout,
                "Cerrar sesión",
                fontScale: fontScale,
                onTap: () => _logout(context),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Boton para que el artesano pueda publicar sus productos
  Widget _publishButton(double fontScale) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [VyntaColors.brandPurple, Color(0xFF9C5BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(VyntaColors.radius),
          boxShadow: [
            BoxShadow(
              color: VyntaColors.brandPurple.withValues(alpha: 0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_business,
              color: VyntaColors.cardWhite,
              size: 26,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Publicá tu artesanía",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: VyntaColors.cardWhite,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Vendé en tu taller",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12 * fontScale,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: VyntaColors.cardWhite),
          ],
        ),
      ),
    );
  }
}

// Opcion del menú del perfil
class _Option extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final double fontScale;

  const _Option(this.icon, this.text, {this.onTap, required this.fontScale});

  @override
  Widget build(BuildContext context) {
    // Colores adaptados al tema seleccionado
    final textColor = AccessibilityColors.text(context);
    final backgroundColor = AccessibilityColors.background(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          // modo gris o negro
          color: backgroundColor == Colors.white
              ? VyntaColors.cardWhite
              : backgroundColor,
          borderRadius: BorderRadius.circular(VyntaColors.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,

          // Icono de opcion
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VyntaColors.contentGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: VyntaColors.brandPurple),
          ),

          // Texto del menu con el tamaño adaptable
          title: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }
}

// Titulos de los menus
class _SectionTitle extends StatelessWidget {
  final String title;
  final double fontScale;

  const _SectionTitle(this.title, {required this.fontScale});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13 * fontScale,
        fontWeight: FontWeight.bold,
        color: VyntaColors.brandPurple,
        letterSpacing: 0.5,
      ),
    );
  }
}
