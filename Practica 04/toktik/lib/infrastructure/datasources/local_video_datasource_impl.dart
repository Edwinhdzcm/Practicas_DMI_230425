import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_posts.dart';

class LocalVideoDatasource implements VideoPostDatasource {

  @override
  VideoSource get source => VideoSource.local;

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {

    // Los datos locales caben en una sola pagina.
    if ( page > 1 ) return [];

    await Future.delayed( const Duration(seconds: 2) );

    final List<VideoPost> newVideos = videoPosts.map(
      ( video ) => LocalVideoModel.fromJson(video).toVideoPostEntity()
    ).toList();

    return newVideos;
  }

  @override
  Future<String> resolveStreamUrl(String sourceId) async => sourceId;

}
