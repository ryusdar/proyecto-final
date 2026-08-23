import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../core/vynta_colors.dart';
import '../core/vynta_store.dart';

/// Shell principal de la app (accesible una vez que el usuario inició sesión).
/// Mantiene una barra de navegación inferior persistente con las 4 secciones
/// principales: Home, Carrito, Favoritos y Perfil.
///
/// Usa [IndexedStack] para conservar el estado de cada pestaña al cambiar
/// de una a otra. Las pantallas de detalle (producto, categoría, búsqueda,
/// checkout, publicación, etc.) se abren por encima de este shell.
class MainShell extends StatefulWidget {
  /// Índice de la pestaña inicial (0 = Home).
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VyntaColors.contentGrey,
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          CartScreen(showBack: false),
          FavoritesScreen(showBack: false),
          ProfileScreen(showBack: false),
        ],
      ),
      // Barra de navegación inferior persistente (accent turquesa el activo).
      bottomNavigationBar: ListenableBuilder(
        listenable: VyntaStore.instance,
        builder: (context, _) {
          final store = VyntaStore.instance;
          return NavigationBar(
            backgroundColor: VyntaColors.cardWhite,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              NavigationDestination(
                icon: _ShellIcon(
                  icon: Icons.shopping_cart_outlined,
                  badge: store.cartCount,
                ),
                selectedIcon: _ShellIcon(
                  icon: Icons.shopping_cart,
                  badge: store.cartCount,
                ),
                label: 'Carrito',
              ),
              NavigationDestination(
                icon: _ShellIcon(
                  icon: Icons.favorite_outline,
                  badge: store.favoritesCount,
                ),
                selectedIcon: _ShellIcon(
                  icon: Icons.favorite,
                  badge: store.favoritesCount,
                ),
                label: 'Favoritos',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Ícono de pestaña con badge de contador (carrito/favoritos).
class _ShellIcon extends StatelessWidget {
  final IconData icon;
  final int badge;

  const _ShellIcon({required this.icon, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: badge > 0,
      label: Text('$badge'),
      child: Icon(icon),
    );
  }
}
