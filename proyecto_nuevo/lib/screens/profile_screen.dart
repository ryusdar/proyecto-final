import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'publish_screen.dart';
import '../core/vynta_colors.dart';
import '../widgets/build_footer.dart';

class ProfileScreen extends StatelessWidget {
  /// Si es falso  no muestra el botón de volver.
  final bool showBack;
  const ProfileScreen({super.key, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: Center(
        child: Container(
          width: 390,
          color: VyntaColors.contentGrey,
          child: Column(
            children: [
              // Header de perfil
              Container(
                width: double.infinity,
                height: 230,
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
                    if (showBack)
                      Positioned(
                        top: 20,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: VyntaColors.ink,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: VyntaColors.brandPurple,
                              child: Icon(
                                Icons.person,
                                size: 54,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Carlos Alberto Paviño",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: VyntaColors.ink,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "carlospalito123@gmail.com",
                            style: TextStyle(
                              color: VyntaColors.ink,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    // Acceso al panel del artesano
                    _publishButton(context),
                    const SizedBox(height: 20),
                    const _SectionTitle("Mi cuenta"),
                    const SizedBox(height: 8),
                    const _Option(Icons.info_outline, "Información personal"),
                    _Option(
                      Icons.favorite_outline,
                      "Favoritos",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    const _Option(Icons.shopping_bag_outlined, "Compras"),
                    const _Option(Icons.payment_outlined, "Métodos de pago"),
                    const SizedBox(height: 20),
                    const _SectionTitle("Más"),
                    const SizedBox(height: 8),
                    const _Option(Icons.settings_outlined, "Configuración"),
                    const _Option(Icons.help_outline, "Ayuda"),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: BuildFooter(color: Colors.black45),
              ),
            ],
          ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: VyntaColors.cardWhite,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Vendé en tu taller",
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
