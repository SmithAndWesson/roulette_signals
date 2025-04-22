import 'package:just_audio/just_audio.dart';
import 'package:roulette_signals/utils/logger.dart';

class SoundPlayer {
  static const String _pingSoundPath = 'assets/sounds/ping.mp3';
  final _audioPlayer = AudioPlayer();

  Future<void> playPing() async {
    try {
      await _audioPlayer
          .setAsset(_pingSoundPath); // ex: assets/sounds/douzina.mp3
      await _audioPlayer.play();
    } catch (e, st) {
      Logger.error('Ошибка воспроизведения звука', e, st);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
