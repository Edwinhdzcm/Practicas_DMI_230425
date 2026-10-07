import 'package:dio/dio.dart';
import 'package:toktik/config/api_config.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/facebook_video_model.dart';

class FacebookVideoDatasource implements VideoPostDatasource {
  final Dio _dio;

  FacebookVideoDatasource({Dio? dio})
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
    if (!ApiConfig.hasFacebook) return [];

    final response = await _dio.get(
      '/${ApiConfig.facebookPageId}/videos',
      queryParameters: {
        'fields': 'id,description,source,likes.summary(true),views',
        'limit': ApiConfig.videosPerSource,
        'access_token': ApiConfig.facebookAccessToken,
      },
    );

    final items = (response.data['data'] as List?) ?? [];
    final videos = <VideoPost>[];

    for (final item in items) {
      final model = FacebookVideoModel.fromJson(item as Map<String, dynamic>);
      if (model.isPlayableVideo) videos.add(model.toVideoPostEntity());
    }

    return videos;
  }
}
