import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/widgets/theme/season_selector_sheet.dart';

/// Barra superior: pestañas Discover / For You / Favorites + selector de tema.
class HomeTopBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const HomeTopBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().theme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const SizedBox(width: 48),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    GestureDetector(
                      onTap: () => onTabSelected(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tabs[i],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: i == currentIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: i == currentIndex
                                    ? Colors.white
                                    : Colors.white60,
                                shadows: const [
                                  Shadow(blurRadius: 4, color: Colors.black54)
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 3,
                              width: i == currentIndex ? 24 : 0,
                              color: theme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Cambiar tema',
              // Icono y color fijos: el botón no cambia con la temporada.
              icon: Icon(
                SeasonTheme.normal.themeIcon,
                color: SeasonTheme.normal.primary,
              ),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<ThemeProvider>(),
                  child: const SeasonSelectorSheet(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
