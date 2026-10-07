import 'package:toktik/domain/entities/video_post.dart';

/// Un elemento de `GET /youtube/v3/videos?part=snippet,statistics`.
class YoutubeVideoModel {
  final String id;
  final String title;
  final int likeCount;
  final int viewCount;

  YoutubeVideoModel({
    required this.id,
    required this.title,
    this.likeCount = 0,
    this.viewCount = 0,
  });

  factory YoutubeVideoModel.fromJson(Map<String, dynamic> json) {
    final snippet = (json['snippet'] as Map<String, dynamic>?) ?? {};
    final statistics = (json['statistics'] as Map<String, dynamic>?) ?? {};

    return YoutubeVideoModel(
      id: json['id'] as String,
      title: snippet['title'] ?? 'Sin título',
      // YouTube manda los contadores como String
      likeCount: int.tryParse('${statistics['likeCount'] ?? 0}') ?? 0,
      viewCount: int.tryParse('${statistics['viewCount'] ?? 0}') ?? 0,
    );
  }

  VideoPost toVideoPostEntity() => VideoPost(
        id: 'yt:$id',
        caption: title,
        videoUrl: id, // aquí va el id; la URL real se resuelve al reproducir
        source: VideoSource.youtube,
        likes: likeCount,
        views: viewCount,
      );
}
