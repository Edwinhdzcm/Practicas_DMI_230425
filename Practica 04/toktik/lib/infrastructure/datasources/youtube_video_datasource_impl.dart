import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/infrastructure/models/youtube_video_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Videos de YouTube. Se buscan con youtube_explode_dart y se reproducen
/// con el stream "muxed" (audio + video) de mayor calidad disponible.
class YoutubeVideoDatasource implements VideoPostDatasource {
  final YoutubeExplode _yt;
  final int videosPerPage;

  /// Cada página usa una búsqueda distinta para tener contenido variado.
  static const _queries = [
    'shorts funny animals',
    'nature vertical video',
    'cooking quick recipe',
    'travel short video',
  ];

  YoutubeVideoDatasource({YoutubeExplode? client, this.videosPerPage = 4})
      : _yt = client ?? YoutubeExplode();

  @override
  VideoSource get source => VideoSource.youtube;

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final query = _queries[(page - 1) % _queries.length];

    final results = await _yt.search.search(query);
    final candidates = results.take(videosPerPage).toList();

    final futures = candidates.map((video) async {
      try {
        final url = await resolveStreamUrl(video.id.value);
        return YoutubeVideoModel(
          id: video.id.value,
          title: video.title,
          description: video.description,
          views: video.engagement.viewCount,
          likes: video.engagement.likeCount ?? 0,
          streamUrl: url,
        ).toVideoPostEntity();
      } catch (_) {
        return null; // video sin stream disponible: se omite
      }
    });

    final videos = await Future.wait(futures);
    return videos.whereType<VideoPost>().toList();
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<String> resolveStreamUrl(String sourceId) async {
    final manifest = await _yt.videos.streamsClient.getManifest(sourceId);
    return manifest.muxed.withHighestBitrate().url.toString();
  }
}
