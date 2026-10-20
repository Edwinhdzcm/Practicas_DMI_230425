import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

/// For You: combina varios datasources remotos (YouTube, Dailymotion, Vimeo).
/// Si uno falla, los demás siguen funcionando.
class ForYouRepositoryImpl implements VideoPostRepository {
  final List<VideoPostDatasource> dataSources;

  ForYouRepositoryImpl(this.dataSources)
      : assert(dataSources.isNotEmpty, 'Se necesita al menos un datasource');

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final results = await Future.wait(
      dataSources.map((ds) async {
        try {
          return await ds.getTrendingVideosByPage(page);
        } catch (_) {
          return <VideoPost>[];
        }
      }),
    );

    // Intercala los resultados: 1 de cada fuente, por turnos.
    final merged = <VideoPost>[];
    final longest =
        results.fold<int>(0, (max, l) => l.length > max ? l.length : max);

    for (var i = 0; i < longest; i++) {
      for (final list in results) {
        if (i < list.length) merged.add(list[i]);
      }
    }
    return merged;
  }
}
