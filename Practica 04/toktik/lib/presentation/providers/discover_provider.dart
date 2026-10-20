import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/presentation/providers/video_feed_provider.dart';

/// Seccion Discover (datasource local).
class DiscoverProvider extends VideoFeedProvider {

  DiscoverProvider({
    required VideoPostRepository videosRepositoy
  }): super( videosRepositoy );

}
