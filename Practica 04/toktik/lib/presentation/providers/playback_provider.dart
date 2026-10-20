import 'package:flutter/foundation.dart';
import 'package:toktik/domain/repositories/settings_repository.dart';

/// Estado global de sonido de los videos (mute / unmute).
class PlaybackProvider extends ChangeNotifier {
  final SettingsRepository repository;

  PlaybackProvider(this.repository);

  // En web el autoplay con sonido suele estar bloqueado.
  bool isMuted = kIsWeb;

  Future<void> init() async {
    isMuted = await repository.getMuted() ?? kIsWeb;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    notifyListeners();
    await repository.saveMuted(isMuted);
  }
}
