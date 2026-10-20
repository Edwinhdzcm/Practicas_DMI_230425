import 'package:toktik/domain/datasources/local_storage_datasource.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalStorageDataSource storage;

  SettingsRepositoryImpl(this.storage);

  @override
  Future<Season?> getSeasonOverride() async =>
      Season.tryParse(await storage.getSeasonOverride());

  @override
  Future<void> saveSeasonOverride(Season? season) =>
      storage.saveSeasonOverride(season?.name);

  @override
  Future<bool?> getMuted() => storage.getMuted();

  @override
  Future<void> saveMuted(bool muted) => storage.saveMuted(muted);
}
