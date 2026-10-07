import 'package:flutter/foundation.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

/// Junta varios datasources (local, YouTube, Instagram, Facebook).
/// Si uno falla, los demás siguen funcionando.
class VideoPostsRepositoryImpl implements VideoPostRepository {
  final List<VideoPostDatasource> datasources;

  VideoPostsRepositoryImpl({required this.datasources})
      : assert(datasources.isNotEmpty, 'Se necesita al menos un datasource');

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    // Todas las fuentes se piden en paralelo
    final results = await Future.wait(
      datasources.map((datasource) => _safeFetch(datasource, page)),
    );

    // Se intercalan (1 de cada fuente, luego el siguiente...) para que el
    // feed no sea "primero todo YouTube, luego todo Instagram".
    var longest = 0;
    for (final list in results) {
      if (list.length > longest) longest = list.length;
    }

    final merged = <VideoPost>[];
    for (var i = 0; i < longest; i++) {
      for (final list in results) {
        if (i < list.length) merged.add(list[i]);
      }
    }

    return merged;
  }

  Future<List<VideoPost>> _safeFetch(
    VideoPostDatasource datasource,
    int page,
  ) async {
    try {
      return await datasource.getTrendingVideosByPage(page);
    } catch (e) {
      debugPrint('Error en ${datasource.runtimeType}: $e');
      return [];
    }
  }
}
