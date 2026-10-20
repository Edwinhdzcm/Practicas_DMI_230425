import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/app_icon_service.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';

/// Mecanismo de prueba: permite forzar cualquier temporada.
/// Se guarda en local storage; "Automático" vuelve a usar la fecha.
class SeasonSelectorSheet extends StatelessWidget {
  const SeasonSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final accent = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Corregido aquí
        children: [
          const SizedBox(height: 12),
          Text('Tema de temporada',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          ListTile(
            leading: const Text('🕒', style: TextStyle(fontSize: 24)),
            title: Text(
                'Automático (${SeasonTheme.of(provider.autoSeason).name})'),
            subtitle: const Text('Según la fecha del dispositivo'),
            trailing: provider.seasonOverride == null
                ? Icon(Icons.check_circle, color: accent)
                : null,
            onTap: () async {
              await provider.setOverride(null);
              final season = provider.season;
              await AppIconService.applySeason(season);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          for (final season in Season.values)
            ListTile(
              leading: Text(SeasonTheme.of(season).emoji,
                  style: const TextStyle(fontSize: 24)),
              title: Text(SeasonTheme.of(season).name),
              trailing: provider.seasonOverride == season
                  ? Icon(Icons.check_circle, color: accent)
                  : null,
              onTap: () async {
                await provider.setOverride(season);
                await AppIconService.applySeason(season);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}