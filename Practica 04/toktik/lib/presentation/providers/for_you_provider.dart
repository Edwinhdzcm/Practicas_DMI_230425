import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/presentation/providers/video_feed_provider.dart';

/// Seccion For You (datasources remotos).
class ForYouProvider extends VideoFeedProvider {

  ForYouProvider({
    required VideoPostRepository videosRepositoy
  }): super( videosRepositoy );

}
