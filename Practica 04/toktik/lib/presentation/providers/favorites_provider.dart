import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/likes_repository.dart';

/// Likes + sección Favorites. Todo se persiste en local storage.
class FavoritesProvider extends ChangeNotifier {
  final LikesRepository repository;

  FavoritesProvider(this.repository);

  bool loading = true;
  final Set<String> _liked = {};
  final Map<String, int> _counts = {};
  List<VideoPost> favorites = [];

  Future<void> init() async {
    _liked.addAll(await repository.getLikedIds());
    _counts.addAll(await repository.getLikeCounts());
    notifyListeners(); // los corazones ya se pintan bien

    favorites = await repository.getFavorites();
    loading = false;
    notifyListeners();
  }

  bool isLiked(String id) => _liked.contains(id);

  /// Likes mostrados: el valor guardado o, si no hay, el original del video.
  int likesFor(VideoPost video) => _counts[video.id] ?? video.likes;

  Future<void> toggleLike(VideoPost video) async {
    final wasLiked = isLiked(video.id);
    final current = likesFor(video);
    final newCount = wasLiked ? (current > 0 ? current - 1 : 0) : current + 1;

    if (wasLiked) {
      _liked.remove(video.id);
      favorites = favorites.where((v) => v.id != video.id).toList();
    } else {
      _liked.add(video.id);
      favorites = [video.copyWith(likes: newCount), ...favorites];
    }
    _counts[video.id] = newCount;
    notifyListeners();

    await repository.setLike(video, liked: !wasLiked, count: newCount);
  }
}
