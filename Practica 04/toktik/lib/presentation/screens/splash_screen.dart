import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/app_icon_service.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/screens/home_screen.dart';

/// Splash de la app: muestra el logo + los 6 iconos laterales
/// (like, comentarios, guardar, compartir, vistas y disco)
/// con el tema de la temporada actual (según la fecha del dispositivo).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Aplica el icono del launcher cuando ya se cargó la temporada
    // (fecha del dispositivo u override guardado) y entra al feed con fundido.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ThemeProvider>();
      await provider.ready;
      if (!mounted) return;
      await AppIconService.applySeason(provider.season);
    });
    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().theme;
    final season = context.watch<ThemeProvider>().season;
    final now = DateTime.now();
    final dateLabel = DateFormat('d MMM yyyy').format(now);

    final icons = <Map<String, dynamic>>[
      {'label': 'Like', 'icon': theme.likedIcon},
      {'label': 'Comentarios', 'icon': theme.commentIcon},
      {'label': 'Guardar', 'icon': theme.savedIcon},
      {'label': 'Compartir', 'icon': theme.shareIcon},
      {'label': 'Vistas', 'icon': theme.viewsIcon},
      {'label': 'Disco', 'icon': theme.discIcon},
    ];

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono del launcher de la temporada actual
                // (normal = img.jpg, Halloween = 3.jpg,
                //  Navidad = 2.jpg, Valentín = 1.jpg).
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    theme.iconAsset,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'TokTik',
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.primary.withAlpha(90)),
                  ),
                  child: Text(
                    '${theme.emoji} ${theme.name} · $dateLabel',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Los 6 iconos laterales con el tema actual
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    for (final item in icons)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.surface,
                              border: Border.all(
                                color: theme.primary.withAlpha(110),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['label'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Temporada: ${season.name}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
