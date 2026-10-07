import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/storage/local_storage_service.dart';

class DiscoverProvider extends ChangeNotifier {
  final VideoPostRepository videosRepositoy;
  final LocalStorageService storage;

  bool initialLoading = true;
  bool isMuted = true;
  List<VideoPost> videos = [];

  Set<String> _likedIds = {};

  DiscoverProvider({
    required this.videosRepositoy,
    LocalStorageService? storage,
  }) : storage = storage ?? LocalStorageService();

  Future<void> loadNextPage() async {
    // 1. Preferencias guardadas
    _likedIds = await storage.loadLikedIds();
    isMuted = await storage.loadMuted();

    // 2. Feed en caché: se muestra al instante mientras llegan las APIs
    final cached = await storage.loadVideos();
    if (cached.isNotEmpty) {
      videos = _applyLikes(cached);
      initialLoading = false;
      notifyListeners();
    }

    // 3. Feed fresco (local + YouTube + Instagram + Facebook)
    final fresh = await videosRepositoy.getTrendingVideosByPage(1);
    if (fresh.isNotEmpty) {
      videos = _applyLikes(fresh);
      await storage.saveVideos(fresh);
    }

    initialLoading = false;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    notifyListeners();
    await storage.saveMuted(isMuted);
  }

  Future<void> toggleLike(String videoId) async {
    final index = videos.indexWhere((video) => video.id == videoId);
    if (index == -1) return;

    final liked = !videos[index].isLiked;
    videos[index] = videos[index].copyWith(isLiked: liked);

    if (liked) {
      _likedIds.add(videoId);
    } else {
      _likedIds.remove(videoId);
    }

    notifyListeners();
    await storage.saveLikedIds(_likedIds);
  }

  List<VideoPost> _applyLikes(List<VideoPost> list) => list
      .map((video) => video.copyWith(isLiked: _likedIds.contains(video.id)))
      .toList();
}
