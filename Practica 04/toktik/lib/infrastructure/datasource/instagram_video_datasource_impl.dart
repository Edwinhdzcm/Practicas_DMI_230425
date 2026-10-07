import 'package:dio/dio.dart';
import 'package:toktik/config/api_config.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/instagram_media_model.dart';

class InstagramVideoDatasource implements VideoPostDatasource {
  final Dio _dio;

  InstagramVideoDatasource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://graph.facebook.com/${ApiConfig.graphVersion}',
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ));

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    if (!ApiConfig.hasInstagram) return [];

    final response = await _dio.get(
      '/${ApiConfig.instagramUserId}/media',
      queryParameters: {
        'fields': 'id,caption,media_type,media_url,like_count',
        'limit': ApiConfig.videosPerSource,
        'access_token': ApiConfig.instagramAccessToken,
      },
    );

    final items = (response.data['data'] as List?) ?? [];
    final videos = <VideoPost>[];

    for (final item in items) {
      final model = InstagramMediaModel.fromJson(item as Map<String, dynamic>);
      if (model.isPlayableVideo) videos.add(model.toVideoPostEntity());
    }

    return videos;
  }
}
