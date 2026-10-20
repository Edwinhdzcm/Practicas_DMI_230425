import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

class YoutubeVideoModel {
  final String id;
  final String title;
  final String description;
  final String streamUrl;
  final int views;
  final int likes;

  YoutubeVideoModel({
    required this.id,
    required this.title,
    required this.streamUrl,
    this.description = '',
    this.views = 0,
    this.likes = 0,
  });

  VideoPost toVideoPostEntity() => VideoPost(
        id: '${VideoSource.youtube.name}:$id',
        caption: title,
        description: description,
        videoUrl: streamUrl,
        likes: likes,
        views: views,
        source: VideoSource.youtube,
        sourceId: id,
      );
}
