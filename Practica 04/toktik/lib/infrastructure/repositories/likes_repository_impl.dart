import 'dart:convert';

import 'package:toktik/domain/datasources/local_storage_datasource.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/domain/repositories/likes_repository.dart';
import 'package:toktik/infrastructure/models/stored_video_model.dart';

/// Favorites: los datos viven en el local storage. Las URLs de los videos
/// remotos se vuelven a pedir a su datasource porque pueden caducar.
class LikesRepositoryImpl implements LikesRepository {
  final LocalStorageDataSource storage;
  final Map<VideoSource, VideoPostDatasource> resolvers;

  LikesRepositoryImpl({required this.storage, required this.resolvers});

  @override
  Future<Set<String>> getLikedIds() => storage.getLikedIds();

  @override
  Future<Map<String, int>> getLikeCounts() => storage.getLikeCounts();

  @override
  Future<void> setLike(
    VideoPost video, {
    required bool liked,
    required int count,
  }) async {
    await storage.saveLike(id: video.id, liked: liked, count: count);

    final stored = await _readFavorites();
    stored.removeWhere((v) => v.id == video.id);
    if (liked) stored.insert(0, video.copyWith(likes: count));

    await storage.saveFavoritesJson(
      stored.map((v) => jsonEncode(StoredVideoModel.toJson(v))).toList(),
    );
  }

  @override
  Future<List<VideoPost>> getFavorites() async {
    final stored = await _readFavorites();

    final refreshed = await Future.wait(stored.map((video) async {
      final resolver = resolvers[video.source];
      if (video.isLocal || resolver == null) return video;
      try {
        final url = await resolver.resolveStreamUrl(video.sourceId);
        return video.copyWith(videoUrl: url);
      } catch (_) {
        return video; // se queda con la última URL conocida
      }
    }));

    return refreshed;
  }

  Future<List<VideoPost>> _readFavorites() async {
    final raw = await storage.getFavoritesJson();
    final videos = <VideoPost>[];
    for (final item in raw) {
      try {
        videos.add(StoredVideoModel.fromJson(
            jsonDecode(item) as Map<String, dynamic>));
      } catch (_) {
        // registro corrupto: se ignora
      }
    }
    return videos;
  }
}
