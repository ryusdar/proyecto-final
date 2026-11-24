import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'publish_screen.dart';
import 'login_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';
import '../widgets/app_frame.dart';
import '../widgets/build_footer.dart';

class ProfileScreen extends StatelessWidget {
  /// Si es falso  no muestra el botón de volver.
  final bool showBack;
  const ProfileScreen({super.key, this.showBack = true});

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
    final name = store.userName ?? "Invitado";
    final email = store.userEmail ?? "";

    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: AppFrame(
        color: VyntaColors.contentGrey,
        maxWidth: 900,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header de perfil
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 230),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            VyntaColors.accentTurquoise,
                            Color(0xFF63E6FF),
                          ],
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
                          if (showBack)
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: VyntaColors.ink,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
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
                                      backgroundColor:
                                          VyntaColors.brandPurple,
                                      child: Icon(
                                        Icons.person,
                                        size: 54,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: VyntaColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: VyntaColors.ink,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Opciones (ancho máximo para que no se estiren)
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Acceso al panel del artesano
                              _publishButton(context),
                              const SizedBox(height: 20),
                              const _SectionTitle("Mi cuenta"),
                              const SizedBox(height: 8),
                              const _Option(
                                Icons.info_outline,
                                "Información personal",
                              ),
                              _Option(
                                Icons.favorite_outline,
                                "Favoritos",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FavoritesScreen(),
                                    ),
                                  );
                                },
                              ),
                              const _Option(
                                Icons.shopping_bag_outlined,
                                "Compras",
                              ),
                              const _Option(
                                Icons.payment_outlined,
                                "Métodos de pago",
                              ),
                              const SizedBox(height: 20),
                              const _SectionTitle("Más"),
                              const SizedBox(height: 8),
                              const _Option(
                                Icons.settings_outlined,
                                "Configuración",
                              ),
                              const _Option(Icons.help_outline, "Ayuda"),
                              _Option(
                                Icons.logout,
                                "Cerrar sesión",
                                onTap: () => _logout(context),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: BuildFooter(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  /// Botón destacado para ir al panel de publicación del artesano.
  Widget _publishButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PublishScreen()),
        );
      },
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
        child: const Row(
          children: [
            Icon(Icons.add_business, color: VyntaColors.cardWhite, size: 26),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Publicá tu artesanía",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: VyntaColors.cardWhite,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Vendé en tu taller",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: VyntaColors.cardWhite),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option(this.icon, this.text, {this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: VyntaColors.cardWhite,
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
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VyntaColors.contentGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: VyntaColors.brandPurple),
          ),
          title: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: VyntaColors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: VyntaColors.brandPurple,
        letterSpacing: 0.5,
      ),
    );
  }
}