import 'package:toktik/domain/entities/video_post.dart';

abstract class LikesRepository {
  Future<Set<String>> getLikedIds();
  Future<Map<String, int>> getLikeCounts();

  /// Guarda el like (o lo quita) y el contador resultante.
  Future<void> setLike(VideoPost video,
      {required bool liked, required int count});

  /// Videos marcados con "me gusta" (con URL actualizada).
  Future<List<VideoPost>> getFavorites();
}
