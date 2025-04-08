import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:roulette_signals/models/game_models.dart';

class TableSocket {
  final String tableId;
  final String evoSessionId;
  late WebSocketChannel _channel;
  final Function(RouletteNumber) onNumberReceived;

  TableSocket({
    required this.tableId,
    required this.evoSessionId,
    required this.onNumberReceived,
  });

  void connect() {
    final uri = Uri.parse(
      'wss://royal.evo-games.com/public/roulette/player/game/$tableId/socket?EVOSESSIONID=$evoSessionId',
    );

    _channel = WebSocketChannel.connect(uri);

    _channel.stream.listen(
      (message) {
        _handleMessage(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final data = message as Map<String, dynamic>;
      
      if (data['type'] == 'roulette.tableState' && 
          data['state'] == 'GAME_RESOLVED') {
        final number = _extractNumber(data);
        if (number != null) {
          onNumberReceived(number);
        }
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  RouletteNumber? _extractNumber(Map<String, dynamic> data) {
    try {
      final result = data['result'] as List;
      if (result.isNotEmpty) {
        final number = int.parse(result[0]);
        return RouletteNumber(
          number: number,
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error extracting number: $e');
    }
    return null;
  }

  void disconnect() {
    _channel.sink.close();
  }
} 