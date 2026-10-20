import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';
import 'package:toktik/presentation/screens/favorites_screen.dart';
import 'package:toktik/presentation/screens/for_you_screen.dart';
import 'package:toktik/presentation/widgets/shared/home_top_bar.dart';
import 'package:toktik/presentation/widgets/shared/keep_alive_page.dart';

/// Pantalla principal: 3 secciones con desplazamiento lateral.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _tabs = ['Discover', 'For You', 'Favorites'];

  final PageController _controller = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    // Jingle de la temporada al abrir la app
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ThemeProvider>();
      provider.playJingle();
      await provider.syncLauncherIcon();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            children: [
              KeepAlivePage(child: DiscoverScreen(isActive: _current == 0)),
              KeepAlivePage(child: ForYouScreen(isActive: _current == 1)),
              KeepAlivePage(child: FavoritesScreen(isActive: _current == 2)),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeTopBar(
              tabs: _tabs,
              currentIndex: _current,
              onTabSelected: (i) => _controller.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
