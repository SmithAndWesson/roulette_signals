import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:roulette_signals/utils/logger.dart';

class SoundPlayer {
  static const String _pingSoundPath = 'assets/sounds/ping.mp3';
  final _audioPlayer = AssetsAudioPlayer();

  Future<void> playPing() async {
    try {
      await _audioPlayer.open(
        Audio(_pingSoundPath),
        autoStart: true,
        showNotification: false,
      );
    } catch (e) {
      Logger.error('Ошибка воспроизведения звука', e);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
