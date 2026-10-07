import 'package:toktik/domain/entities/video_post.dart';

/// Un elemento de `GET /{page-id}/videos`.
class FacebookVideoModel {
  final String id;
  final String description;
  final String? source;
  final int likes;
  final int views;

  FacebookVideoModel({
    required this.id,
    required this.description,
    required this.source,
    this.likes = 0,
    this.views = 0,
  });

  factory FacebookVideoModel.fromJson(Map<String, dynamic> json) {
    // likes.summary(true) responde: { "likes": { "summary": { "total_count": 5 } } }
    final likesNode = json['likes'] as Map<String, dynamic>?;
    final summary = likesNode?['summary'] as Map<String, dynamic>?;

    return FacebookVideoModel(
      id: json['id'] as String,
      description: json['description'] ?? 'Facebook',
      source: json['source'] as String?,
      likes: summary?['total_count'] ?? 0,
      views: json['views'] ?? 0,
    );
  }

  bool get isPlayableVideo => source?.isNotEmpty ?? false;

  VideoPost toVideoPostEntity() => VideoPost(
        id: 'fb:$id',
        caption: description,
        videoUrl: source!,
        source: VideoSource.facebook,
        likes: likes,
        views: views,
      );
}
