import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:toktik/config/helpers/app_icon_service.dart';
import 'package:toktik/config/helpers/season_audio_player.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/season.dart';
import 'package:toktik/domain/repositories/settings_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsRepository repository;
  final SeasonAudioPlayer audio;

  ThemeProvider({required this.repository, required this.audio});

  /// Temporada forzada para pruebas. null = automática (fecha del dispositivo).
  Season? _seasonOverride;

  /// Se completa cuando termina [init] (ya se cargó la temporada guardada).
  final Completer<void> _ready = Completer<void>();

  Season? get seasonOverride => _seasonOverride;
  Season get autoSeason => Season.fromDate(DateTime.now());
  Season get season => _seasonOverride ?? autoSeason;
  SeasonTheme get theme => SeasonTheme.of(season);

  Future<void> get ready => _ready.future;

  Future<void> init() async {
    try {
      _seasonOverride = await repository.getSeasonOverride();
      notifyListeners();
    } finally {
      if (!_ready.isCompleted) _ready.complete();
    }
  }

  Future<void> setOverride(Season? value) async {
    _seasonOverride = value;
    notifyListeners();
    await repository.saveSeasonOverride(value);
    await playJingle();
  }

  Future<void> playJingle() => audio.play(theme.audioAsset);

  /// Mantiene el icono del launcher sincronizado con la temporada activa.
  ///
  /// Se llama al abrir la app para que el icono no se quede viejo
  /// (por ejemplo, tras instalar la app en plena temporada de Halloween).
  Future<void> syncLauncherIcon() => AppIconService.applySeason(season);

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }
}