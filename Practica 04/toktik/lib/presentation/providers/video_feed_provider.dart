import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

/// Lógica común de una sección paginada (Discover, For You).
class VideoFeedProvider extends ChangeNotifier {
  final VideoPostRepository repository;

  VideoFeedProvider(this.repository);

  bool initialLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? error;
  int _page = 0;
  final List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;

    try {
      final newVideos = await repository.getTrendingVideosByPage(_page + 1);
      _page++;

      // Evita duplicados entre páginas
      final known = videos.map((v) => v.id).toSet();
      final fresh = newVideos.where((v) => !known.contains(v.id)).toList();

      if (newVideos.isEmpty) hasMore = false;
      videos.addAll(fresh);
      error = null;
    } catch (e) {
      error = 'No se pudieron cargar los videos';
    } finally {
      initialLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    error = null;
    initialLoading = true;
    notifyListeners();
    await loadNextPage();
  }
}
