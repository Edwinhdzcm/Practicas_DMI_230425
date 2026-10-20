import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';

class LocalVideoModel {
  final String name;
  final String description;
  final String videoUrl;
  final int likes;
  final int views;

  LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.description = '',
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'] ?? 'No name',
        description: json['description'] ?? '',
        videoUrl: json['videoUrl'],
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
      );

  VideoPost toVideoPostEntity() => VideoPost(
        id: '${VideoSource.local.name}:$videoUrl',
        caption: name,
        description: description,
        videoUrl: videoUrl,
        likes: likes,
        views: views,
        source: VideoSource.local,
        sourceId: videoUrl,
      );
}
