import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/cached_video_model.dart';

/// Almacenamiento local (shared_preferences).
/// En web usa `localStorage` del navegador; en móvil/escritorio, archivos nativos.
class LocalStorageService {
  static const _videosKey = 'toktik_cached_videos';
  static const _likedKey = 'toktik_liked_video_ids';
  static const _mutedKey = 'toktik_is_muted';

  // ---- Videos (feed en caché) ----

  Future<void> saveVideos(List<VideoPost> videos) async {
    final prefs = await SharedPreferences.getInstance();
    final json = videos
        .map((video) => CachedVideoModel.fromEntity(video).toJson())
        .toList();
    await prefs.setString(_videosKey, jsonEncode(json));
  }

  Future<List<VideoPost>> loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_videosKey);
    if (raw == null) return [];

    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((item) => CachedVideoModel.fromJson(item as Map<String, dynamic>)
              .toVideoPostEntity())
          .toList();
    } catch (_) {
      // Caché corrupta o de una versión vieja: se ignora
      return [];
    }
  }

  // ---- Likes ----

  Future<void> saveLikedIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedKey, ids.toList());
  }

  Future<Set<String>> loadLikedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_likedKey) ?? []).toSet();
  }

  // ---- Mute ----

  Future<void> saveMuted(bool muted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedKey, muted);
  }

  /// Por defecto empieza en mute (los navegadores bloquean el autoplay con sonido).
  Future<bool> loadMuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_mutedKey) ?? true;
  }
}
