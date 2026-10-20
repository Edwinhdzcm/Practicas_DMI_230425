import 'package:toktik/domain/entities/video_source.dart';

class VideoPost {
  /// Identificador único: "<source>:<sourceId>".
  final String id;
  final String caption;
  final String description;
  final String videoUrl;
  final int likes;
  final int views;
  final VideoSource source;
  final String sourceId;

  VideoPost({
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.source,
    required this.sourceId,
    this.description = '',
    this.likes = 0,
    this.views = 0,
  })  : assert(id != '', 'El id no puede estar vacío'),
        assert(videoUrl != '', 'El videoUrl no puede estar vacío'),
        assert(likes >= 0, 'Los likes no pueden ser negativos');

  bool get isLocal => source == VideoSource.local;

  VideoPost copyWith({String? videoUrl, int? likes}) => VideoPost(
        id: id,
        caption: caption,
        description: description,
        videoUrl: videoUrl ?? this.videoUrl,
        likes: likes ?? this.likes,
        views: views,
        source: source,
        sourceId: sourceId,
      );
}
