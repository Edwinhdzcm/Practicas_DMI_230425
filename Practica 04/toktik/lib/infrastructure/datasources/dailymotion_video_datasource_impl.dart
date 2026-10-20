import 'package:dio/dio.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/infrastructure/models/dailymotion_video_model.dart';

/// Videos de Dailymotion (API pública + metadata del player).
class DailymotionVideoDatasource implements VideoPostDatasource {
  final Dio _dio;
  final int videosPerPage;

  DailymotionVideoDatasource({Dio? dio, this.videosPerPage = 4})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));

  @override
  VideoSource get source => VideoSource.dailymotion;

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final response = await _dio.get(
      'https://api.dailymotion.com/videos',
      queryParameters: {
        'fields': 'id,title,description,views_total,likes_total',
        'sort': 'trending',
        'flags': 'no_live',
        'limit': videosPerPage,
        'page': page,
      },
    );

    final list = (response.data['list'] as List).cast<Map<String, dynamic>>();

    final futures = list.map((json) async {
      try {
        final url = await resolveStreamUrl(json['id'].toString());
        return DailymotionVideoModel.fromApiJson(json, streamUrl: url)
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
  Future<String> resolveStreamUrl(String sourceId) async {
    final response = await _dio.get(
      'https://www.dailymotion.com/player/metadata/video/$sourceId',
    );

    final qualities = (response.data['qualities'] ?? {}) as Map<String, dynamic>;

    // 1) mp4 progresivo de hasta 720p, si existe
    final heights = qualities.keys
        .map(int.tryParse)
        .whereType<int>()
        .where((h) => h <= 720)
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final h in heights) {
      for (final item in (qualities['$h'] as List)) {
        if (item['type'] == 'video/mp4') return item['url'] as String;
      }
    }

    // 2) HLS (m3u8) automático
    final auto = qualities['auto'] as List?;
    if (auto != null && auto.isNotEmpty) return auto.first['url'] as String;

    throw Exception('Dailymotion: sin stream disponible para $sourceId');
  }
}
