import 'package:toktik/domain/entities/video_post.dart';

/// Un elemento de `GET /{ig-user-id}/media`.
class InstagramMediaModel {
  final String id;
  final String caption;
  final String mediaType;
  final String? mediaUrl;
  final int likeCount;

  InstagramMediaModel({
    required this.id,
    required this.caption,
    required this.mediaType,
    required this.mediaUrl,
    this.likeCount = 0,
  });

  factory InstagramMediaModel.fromJson(Map<String, dynamic> json) =>
      InstagramMediaModel(
        id: json['id'] as String,
        caption: json['caption'] ?? 'Instagram',
        mediaType: json['media_type'] ?? 'UNKNOWN',
        mediaUrl: json['media_url'] as String?,
        likeCount: json['like_count'] ?? 0,
      );

  /// El feed mezcla fotos, álbumes y videos: solo nos sirven los videos.
  bool get isPlayableVideo =>
      mediaType == 'VIDEO' && (mediaUrl?.isNotEmpty ?? false);

  VideoPost toVideoPostEntity() => VideoPost(
        id: 'ig:$id',
        caption: caption,
        videoUrl: mediaUrl!,
        source: VideoSource.instagram,
        likes: likeCount,
      );
}
