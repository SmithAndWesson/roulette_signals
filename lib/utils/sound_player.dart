import 'package:audioplayers/audioplayers.dart';
import 'logger.dart';

class SoundPlayer {
  SoundPlayer._();

  /// Глобальный доступ: `SoundPlayer.i.playPing();`
  static final SoundPlayer i = SoundPlayer._();

  static const _pingAsset = 'sounds/ping.mp3';

  /// Один экземпляр плеера на всё приложение.
  final _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  /// Проиграть короткий «пинг».
  Future<void> playPing() async {
    try {
      // В 5.x assets проигрываются через AudioCache автоматически.
      await _player.play(AssetSource(_pingAsset), volume: 1.0);
    } catch (e, st) {
      Logger.error('Ошибка воспроизведения звука', e, st);
    }
  }

  Future<void> dispose() => _player.dispose();
}
