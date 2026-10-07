import 'package:toktik/domain/entities/video_post.dart';

/// Mapper entre [VideoPost] y el JSON que se guarda en el almacenamiento local.
/// No guarda `isLiked`: eso se guarda aparte (ids de likes).
class CachedVideoModel {
  final String id;
  final String caption;
  final String videoUrl;
  final String source;
  final int likes;
  final int views;

  CachedVideoModel({
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.source,
    required this.likes,
    required this.views,
  });

  factory CachedVideoModel.fromEntity(VideoPost video) => CachedVideoModel(
        id: video.id,
        caption: video.caption,
        videoUrl: video.videoUrl,
        source: video.source.name,
        likes: video.likes,
        views: video.views,
      );

  factory CachedVideoModel.fromJson(Map<String, dynamic> json) =>
      CachedVideoModel(
        id: json['id'] as String,
        caption: json['caption'] as String,
        videoUrl: json['videoUrl'] as String,
        source: json['source'] as String,
        likes: json['likes'] as int,
        views: json['views'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'caption': caption,
        'videoUrl': videoUrl,
        'source': source,
        'likes': likes,
        'views': views,
      };

  VideoPost toVideoPostEntity() => VideoPost(
        id: id,
        caption: caption,
        videoUrl: videoUrl,
        source: VideoSource.values.firstWhere(
          (s) => s.name == source,
          orElse: () => VideoSource.local,
        ),
        likes: likes,
        views: views,
      );
}
