import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/datasources/local_storage_datasource.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/domain/repositories/likes_repository.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/views_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';

final _video = VideoPost(
  id: 'local:assets/videos/1.mp4',
  caption: 'Prueba',
  videoUrl: 'assets/videos/1.mp4',
  source: VideoSource.local,
  sourceId: 'assets/videos/1.mp4',
  likes: 10,
  views: 100,
);

/// Renderiza [VideoButtons] con el tema de [season] y devuelve los iconos
/// que se pintaron en pantalla.
Future<List<IconData>> _pumpYLeerIconos(
    WidgetTester tester, Season season) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FavoritesProvider(_FakeLikesRepository())),
        ChangeNotifierProvider(create: (_) => ViewsProvider(_FakeStorage())),
      ],
      child: MaterialApp(
        theme: AppTheme(SeasonTheme.of(season)).getTheme(),
        home: Scaffold(body: VideoButtons(video: _video)),
      ),
    ),
  );
  await tester.pump();

  // MaterialApp anima el cambio de tema (200 ms): hay que dejar que
  // termine para leer el tema nuevo y no el anterior.
  await tester.pump(const Duration(milliseconds: 400));

  return tester
      .widgetList<Icon>(find.byType(Icon))
      .map((i) => i.icon)
      .whereType<IconData>()
      .toList();
}

void main() {
  group('Los botones no cambian al cambiar de tema', () {
    testWidgets('Los botones de acción muestran los mismos iconos en todas '
        'las temporadas', (tester) async {
      final iconosPorTemporada = <Season, List<IconData>>{};

      for (final season in Season.values) {
        iconosPorTemporada[season] = await _pumpYLeerIconos(tester, season);
      }

      final referencia = iconosPorTemporada[Season.normal]!;
      expect(referencia, isNotEmpty);

      for (final season in Season.values) {
        expect(
          iconosPorTemporada[season],
          referencia,
          reason: 'Los botones cambian al usar el tema $season',
        );
      }
    });

    test('El color de los botones Material es siempre el de la temporada '
        'Normal', () {
      for (final season in Season.values) {
        final theme = AppTheme(SeasonTheme.of(season)).getTheme();
        final color = theme.textButtonTheme.style?.foregroundColor
            ?.resolve(const <WidgetState>{});

        expect(color, SeasonTheme.normal.primary, reason: 'Tema $season');
      }
    });

    test('El fondo y la tipografía sí cambian con la temporada', () {
      final normal = AppTheme(SeasonTheme.normal).getTheme();
      final halloween = AppTheme(SeasonTheme.of(Season.halloween)).getTheme();

      expect(normal.scaffoldBackgroundColor,
          isNot(halloween.scaffoldBackgroundColor));
      expect(normal.textTheme.bodyMedium?.fontFamily,
          isNot(halloween.textTheme.bodyMedium?.fontFamily));
    });
  });
}

/// Repositorio de likes en memoria.
class _FakeLikesRepository implements LikesRepository {
  @override
  Future<Set<String>> getLikedIds() async => {};

  @override
  Future<Map<String, int>> getLikeCounts() async => {};

  @override
  Future<List<VideoPost>> getFavorites() async => [];

  @override
  Future<void> setLike(VideoPost video,
      {required bool liked, required int count}) async {}
}

/// Almacenamiento local en memoria.
class _FakeStorage implements LocalStorageDataSource {
  @override
  Future<String?> getSeasonOverride() async => null;

  @override
  Future<void> saveSeasonOverride(String? seasonName) async {}

  @override
  Future<bool?> getMuted() async => true;

  @override
  Future<void> saveMuted(bool muted) async {}

  @override
  Future<Set<String>> getLikedIds() async => {};

  @override
  Future<Map<String, int>> getLikeCounts() async => {};

  @override
  Future<void> saveLike({
    required String id,
    required bool liked,
    required int count,
  }) async {}

  @override
  Future<Map<String, int>> getViewCounts() async => {};

  @override
  Future<void> saveViewCount({required String id, required int count}) async {}

  @override
  Future<List<String>> getFavoritesJson() async => [];

  @override
  Future<void> saveFavoritesJson(List<String> items) async {}
}
