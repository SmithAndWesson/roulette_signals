import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:roulette_signals/models/recent_results.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'dart:async';
import 'dart:convert';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;

  Future<RecentResults?> fetchRecentResults(WebSocketParams params) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(params.webSocketUrl));
      _isConnected = true;
      Logger.info('Подключение к WebSocket: ${params.webSocketUrl}');

      final completer = Completer<RecentResults?>();
      final timer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          Logger.warning('Таймаут ожидания recentResults');
          completer.complete(null);
        }
      });

      _channel?.stream.listen(
        (message) {
          try {
            final data = json.decode(message);
            if (data['type'] == 'roulette.tableState' &&
                data['state'] == 'GAME_RESOLVED') {
              final results = RecentResults.fromJson(data);
              if (!completer.isCompleted) {
                completer.complete(results);
              }
              _disconnect();
            }
          } catch (e) {
            Logger.error('Ошибка обработки сообщения WebSocket', e);
          }
        },
        onError: (error) {
          Logger.error('Ошибка WebSocket', error);
          if (!completer.isCompleted) {
            completer.complete(null);
          }
          _disconnect();
        },
        onDone: () {
          Logger.info('Соединение WebSocket закрыто');
          _isConnected = false;
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      );

      return await completer.future;
    } catch (e) {
      Logger.error('Ошибка подключения к WebSocket', e);
      _disconnect();
      return null;
    }
  }

  void _disconnect() {
    if (_isConnected) {
      _channel?.sink.close();
      _isConnected = false;
    }
  }
}
