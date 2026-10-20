import 'package:dio/dio.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/infrastructure/models/vimeo_video_model.dart';

/// Videos públicos de Vimeo (config del player, sin API key).
/// Funciona con videos públicos que permiten embeberse.
class VimeoVideoDatasource implements VideoPostDatasource {
  final Dio _dio;
  final int videosPerPage;

  /// IDs de videos públicos. Cámbialos por los que quieras mostrar.
  final List<String> videoIds;

  VimeoVideoDatasource({
    Dio? dio,
    this.videosPerPage = 3,
    this.videoIds = const ['76979871', '1084537', '22439234'],
  }) : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));

  @override
  VideoSource get source => VideoSource.vimeo;

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final start = (page - 1) * videosPerPage;
    if (start >= videoIds.length) return [];

    final ids = videoIds.skip(start).take(videosPerPage);

    final futures = ids.map((id) async {
      try {
        final config = await _fetchConfig(id);
        final url = _pickProgressiveUrl(config);
        return VimeoVideoModel.fromConfigJson(id, config, streamUrl: url)
            .toVideoPostEntity();
      } catch (_) {
        return null;
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
  Future<String> resolveStreamUrl(String sourceId) async =>
      _pickProgressiveUrl(await _fetchConfig(sourceId));

  Future<Map<String, dynamic>> _fetchConfig(String id) async {
    final response = await _dio.get('https://player.vimeo.com/video/$id/config');
    return Map<String, dynamic>.from(response.data as Map);
  }

  String _pickProgressiveUrl(Map<String, dynamic> config) {
    final files = (config['request']?['files'] ?? {}) as Map;
    final progressive = ((files['progressive'] ?? []) as List)
        .cast<Map<String, dynamic>>()
        .where((f) => (f['height'] ?? 0) <= 720)
        .toList()
      ..sort((a, b) => (b['height'] as int).compareTo(a['height'] as int));

    if (progressive.isEmpty) {
      throw Exception('Vimeo: sin stream progresivo disponible');
    }
    return progressive.first['url'] as String;
  }
}
