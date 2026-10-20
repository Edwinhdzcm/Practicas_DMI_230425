import 'package:flutter_test/flutter_test.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/domain/repositories/likes_repository.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';

/// Repositorio en memoria para probar la lógica de likes sin local storage real.
class _FakeLikesRepository implements LikesRepository {
  final Set<String> liked = {};
  final Map<String, int> counts = {};
  final List<VideoPost> favorites = [];

  @override
  Future<Set<String>> getLikedIds() async => liked;

  @override
  Future<Map<String, int>> getLikeCounts() async => counts;

  @override
  Future<List<VideoPost>> getFavorites() async => favorites;

  @override
  Future<void> setLike(VideoPost video,
      {required bool liked, required int count}) async {
    liked ? this.liked.add(video.id) : this.liked.remove(video.id);
    counts[video.id] = count;
  }
}

void main() {
  group('Season.fromDate', () {
    test('Halloween empieza 10 días antes (21 oct) y termina el 2 nov', () {
      expect(Season.fromDate(DateTime(2026, 10, 20)), Season.normal);
      expect(Season.fromDate(DateTime(2026, 10, 21)), Season.halloween);
      expect(Season.fromDate(DateTime(2026, 10, 31)), Season.halloween);
      expect(Season.fromDate(DateTime(2026, 11, 2)), Season.halloween);
      expect(Season.fromDate(DateTime(2026, 11, 3)), Season.normal);
    });
    test('Navidad empieza 10 días antes (15 dic) y termina el 6 ene', () {
      expect(Season.fromDate(DateTime(2026, 12, 14)), Season.normal);
      expect(Season.fromDate(DateTime(2026, 12, 15)), Season.christmas);
      expect(Season.fromDate(DateTime(2026, 12, 25)), Season.christmas);
      expect(Season.fromDate(DateTime(2027, 1, 6)), Season.christmas);
      expect(Season.fromDate(DateTime(2027, 1, 7)), Season.normal);
    });
    test('San Valentín empieza 10 días antes (4 feb) y termina el 15 feb', () {
      expect(Season.fromDate(DateTime(2026, 2, 3)), Season.normal);
      expect(Season.fromDate(DateTime(2026, 2, 4)), Season.valentine);
      expect(Season.fromDate(DateTime(2026, 2, 14)), Season.valentine);
      expect(Season.fromDate(DateTime(2026, 2, 15)), Season.valentine);
      expect(Season.fromDate(DateTime(2026, 2, 16)), Season.normal);
    });
    test('Normal', () {
      expect(Season.fromDate(DateTime(2026, 6, 10)), Season.normal);
    });
  });

  group('FavoritesProvider', () {
    final video = VideoPost(
      id: 'local:assets/videos/1.mp4',
      caption: 'Prueba',
      videoUrl: 'assets/videos/1.mp4',
      source: VideoSource.local,
      sourceId: 'assets/videos/1.mp4',
      likes: 10,
    );

    test('like suma 1, quitar like resta 1 y se persiste', () async {
      final repo = _FakeLikesRepository();
      final provider = FavoritesProvider(repo);
      await provider.init();

      await provider.toggleLike(video);
      expect(provider.isLiked(video.id), true);
      expect(provider.likesFor(video), 11);
      expect(repo.counts[video.id], 11);

      await provider.toggleLike(video);
      expect(provider.isLiked(video.id), false);
      expect(provider.likesFor(video), 10);
      expect(repo.counts[video.id], 10);

      await provider.toggleLike(video);
      expect(provider.likesFor(video), 11);
    });
  });
}
