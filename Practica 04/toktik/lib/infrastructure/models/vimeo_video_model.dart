import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

class VimeoVideoModel {
  final String id;
  final String title;
  final String author;
  final String streamUrl;

  VimeoVideoModel({
    required this.id,
    required this.title,
    required this.author,
    required this.streamUrl,
  });

  /// [json] es la respuesta de https://player.vimeo.com/video/{id}/config
  factory VimeoVideoModel.fromConfigJson(
    String id,
    Map<String, dynamic> json, {
    required String streamUrl,
  }) {
    final video = (json['video'] ?? {}) as Map<String, dynamic>;
    final owner = (video['owner'] ?? {}) as Map<String, dynamic>;
    return VimeoVideoModel(
      id: id,
      title: (video['title'] ?? 'Video de Vimeo').toString(),
      author: (owner['name'] ?? 'Vimeo').toString(),
      streamUrl: streamUrl,
    );
  }

  VideoPost toVideoPostEntity() => VideoPost(
        id: '${VideoSource.vimeo.name}:$id',
        caption: title,
        description: 'Publicado por $author en Vimeo.',
        videoUrl: streamUrl,
        source: VideoSource.vimeo,
        sourceId: id,
      );
}
