import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

/// Mapper entre [VideoPost] y el JSON que se guarda en local storage.
class StoredVideoModel {
  static Map<String, dynamic> toJson(VideoPost v) => {
        'id': v.id,
        'caption': v.caption,
        'description': v.description,
        'videoUrl': v.videoUrl,
        'likes': v.likes,
        'views': v.views,
        'source': v.source.name,
        'sourceId': v.sourceId,
      };

  static VideoPost fromJson(Map<String, dynamic> json) => VideoPost(
        id: json['id'] as String,
        caption: json['caption'] as String,
        description: (json['description'] ?? '') as String,
        videoUrl: json['videoUrl'] as String,
        likes: (json['likes'] ?? 0) as int,
        views: (json['views'] ?? 0) as int,
        source: VideoSource.values.firstWhere(
          (s) => s.name == json['source'],
          orElse: () => VideoSource.local,
        ),
        sourceId: json['sourceId'] as String,
      );
}
