import 'package:dio/dio.dart';
import 'package:toktik/config/api_config.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/youtube_video_model.dart';

class YoutubeVideoDatasource implements VideoPostDatasource {
  final Dio _dio;

  YoutubeVideoDatasource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://www.googleapis.com/youtube/v3',
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ));

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    if (!ApiConfig.hasYoutube) return [];

    final response = await _dio.get('/videos', queryParameters: {
      'part': 'snippet,statistics',
      'chart': 'mostPopular',
      'regionCode': ApiConfig.youtubeRegion,
      'maxResults': ApiConfig.videosPerSource,
      'key': ApiConfig.youtubeApiKey,
    });

    final items = (response.data['items'] as List?) ?? [];
    final videos = <VideoPost>[];

    for (final item in items) {
      final model = YoutubeVideoModel.fromJson(item as Map<String, dynamic>);
      videos.add(model.toVideoPostEntity());
    }

    return videos;
  }
}
