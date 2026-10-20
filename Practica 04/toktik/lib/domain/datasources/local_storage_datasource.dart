/// Contrato del almacenamiento local (SharedPreferences, Hive, etc.).
abstract class LocalStorageDataSource {
  // Tema
  Future<String?> getSeasonOverride();
  Future<void> saveSeasonOverride(String? seasonName);

  // Audio
  Future<bool?> getMuted();
  Future<void> saveMuted(bool muted);

  // Likes
  Future<Set<String>> getLikedIds();
  Future<Map<String, int>> getLikeCounts();
  Future<void> saveLike({
    required String id,
    required bool liked,
    required int count,
  });

  // Vistas
  Future<Map<String, int>> getViewCounts();
  Future<void> saveViewCount({required String id, required int count});

  // Favoritos (JSON serializado de cada video)
  Future<List<String>> getFavoritesJson();
  Future<void> saveFavoritesJson(List<String> items);
}
