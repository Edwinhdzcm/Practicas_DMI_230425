import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

class DailymotionVideoModel {
  final String id;
  final String title;
  final String description;
  final int views;
  final int likes;
  final String streamUrl;

  DailymotionVideoModel({
    required this.id,
    required this.title,
    required this.streamUrl,
    this.description = '',
    this.views = 0,
    this.likes = 0,
  });

  /// [json] es un elemento de la lista que devuelve api.dailymotion.com/videos
  factory DailymotionVideoModel.fromApiJson(
    Map<String, dynamic> json, {
    required String streamUrl,
  }) =>
      DailymotionVideoModel(
        id: json['id'].toString(),
        title: (json['title'] ?? 'Sin título').toString(),
        description: _stripHtml((json['description'] ?? '').toString()),
        views: (json['views_total'] ?? 0) as int,
        likes: (json['likes_total'] ?? 0) as int,
        streamUrl: streamUrl,
      );

  static String _stripHtml(String html) => html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .trim();

  VideoPost toVideoPostEntity() => VideoPost(
        id: '${VideoSource.dailymotion.name}:$id',
        caption: title,
        description: description,
        videoUrl: streamUrl,
        likes: likes,
        views: views,
        source: VideoSource.dailymotion,
        sourceId: id,
      );
}
