import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

abstract class VideoPostDatasource {

  /// Origen de los videos (local, YouTube, Dailymotion, Vimeo).
  VideoSource get source;

  Future<List<VideoPost>> getFavoriteVideosByUser( String userID );

  Future<List<VideoPost>> getTrendingVideosByPage( int page );

  /// URL reproducible actualizada (las de YouTube caducan).
  Future<String> resolveStreamUrl( String sourceId );

}
