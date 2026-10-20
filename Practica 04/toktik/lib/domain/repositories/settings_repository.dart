import 'package:toktik/domain/entities/season.dart';

abstract class SettingsRepository {
  Future<Season?> getSeasonOverride();
  Future<void> saveSeasonOverride(Season? season);
  Future<bool?> getMuted();
  Future<void> saveMuted(bool muted);
}
