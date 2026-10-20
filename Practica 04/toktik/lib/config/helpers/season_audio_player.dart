import 'package:audioplayers/audioplayers.dart';

/// Reproduce el jingle corto de cada temporada.
class SeasonAudioPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath), volume: 0.6);
    } catch (_) {
      // Sin audio no pasa nada (por ejemplo, autoplay bloqueado en web).
    }
  }

  void dispose() => _player.dispose();
}
