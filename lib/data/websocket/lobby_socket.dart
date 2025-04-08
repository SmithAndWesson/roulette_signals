import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/utils/logger.dart';

class LobbySocket {
  final String sessionId;
  late WebSocketChannel _channel;
  final Function(List<RouletteNumber>) onNumbersReceived;

  LobbySocket({
    required this.sessionId,
    required this.onNumbersReceived,
  });

  void connect() {
    final uri = Uri.parse(
      'wss://royal.evo-games.com/public/lobby/socket/v2/$sessionId?messageFormat=json&device=Desktop',
    );

    _channel = WebSocketChannel.connect(uri);

    _channel.stream.listen(
      (message) {
        _handleMessage(message);
      },
      onError: (error) {
        Logger.error('Ошибка WebSocket', error);
      },
      onDone: () {
        Logger.warning('Соединение WebSocket закрыто');
      },
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final data = message as Map<String, dynamic>;
      if (data['type'] == 'lobby.historyUpdated') {
        final numbers = _extractNumbers(data);
        onNumbersReceived(numbers);
      }
    } catch (e) {
      Logger.error('Ошибка обработки сообщения', e);
    }
  }

  List<RouletteNumber> _extractNumbers(Map<String, dynamic> data) {
    final numbers = <RouletteNumber>[];
    // Здесь нужно реализовать извлечение чисел из сообщения
    // и преобразование их в объекты RouletteNumber
    return numbers;
  }

  void disconnect() {
    _channel.sink.close();
  }
}
