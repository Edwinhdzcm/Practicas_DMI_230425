import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/domain/datasources/local_storage_datasource.dart';

/// Implementación del local storage con SharedPreferences.
class PrefsLocalStorageDataSource implements LocalStorageDataSource {
  final SharedPreferences _prefs;

  static const _seasonKey = 'season_override';
  static const _mutedKey = 'muted';
  static const _likedIdsKey = 'liked_ids';
  static const _favoritesKey = 'favorites_json';
  static const _likeCountPrefix = 'like_count:';
  static const _viewCountPrefix = 'view_count:';

  PrefsLocalStorageDataSource(this._prefs);

  @override
  Future<String?> getSeasonOverride() async => _prefs.getString(_seasonKey);

  @override
  Future<void> saveSeasonOverride(String? seasonName) async {
    if (seasonName == null) {
      await _prefs.remove(_seasonKey);
    } else {
      await _prefs.setString(_seasonKey, seasonName);
    }
  }

  @override
  Future<bool?> getMuted() async => _prefs.getBool(_mutedKey);

  @override
  Future<void> saveMuted(bool muted) => _prefs.setBool(_mutedKey, muted);

  @override
  Future<Set<String>> getLikedIds() async =>
      (_prefs.getStringList(_likedIdsKey) ?? <String>[]).toSet();

  @override
  Future<Map<String, int>> getLikeCounts() async {
    final counts = <String, int>{};
    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_likeCountPrefix)) {
        final value = _prefs.getInt(key);
        if (value != null) counts[key.substring(_likeCountPrefix.length)] = value;
      }
    }
    return counts;
  }

  @override
  Future<void> saveLike({
    required String id,
    required bool liked,
    required int count,
  }) async {
    final ids = (_prefs.getStringList(_likedIdsKey) ?? <String>[]).toSet();
    liked ? ids.add(id) : ids.remove(id);

    await _prefs.setStringList(_likedIdsKey, ids.toList());
    await _prefs.setInt('$_likeCountPrefix$id', count);
  }

  @override
  Future<Map<String, int>> getViewCounts() async {
    final counts = <String, int>{};
    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_viewCountPrefix)) {
        final value = _prefs.getInt(key);
        if (value != null) counts[key.substring(_viewCountPrefix.length)] = value;
      }
    }
    return counts;
  }

  @override
  Future<void> saveViewCount({required String id, required int count}) =>
      _prefs.setInt('$_viewCountPrefix$id', count);

  @override
  Future<List<String>> getFavoritesJson() async =>
      _prefs.getStringList(_favoritesKey) ?? <String>[];

  @override
  Future<void> saveFavoritesJson(List<String> items) =>
      _prefs.setStringList(_favoritesKey, items);
}
