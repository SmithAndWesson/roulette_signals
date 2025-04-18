import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:roulette_signals/models/recent_results.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;
  Timer? _timeoutTimer;

  Future<RecentResults?> fetchRecentResults(WebSocketParams params) async {
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(params.webSocketUrl),
        headers: {
          'Cookie': params.cookieHeader,
          'Origin': 'https://royal.evo-games.com',
        },
      );

      final completer = Completer<RecentResults?>();
      _timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          Logger.warning('Таймаут получения результатов');
          completer.complete(null);
          _channel?.sink.close();
        }
      });

      _channel?.stream.listen(
        (message) {
          Logger.debug('Получено сообщение: $message');
          try {
            final results = RecentResults.fromJson(message);
            if (!completer.isCompleted) {
              completer.complete(results);
            }
          } catch (e) {
            Logger.error('Ошибка парсинга результатов', e);
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          }
        },
        onError: (error) {
          Logger.error('Ошибка WebSocket', error);
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
        onDone: () {
          Logger.info('WebSocket соединение закрыто');
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      );

      return await completer.future;
    } catch (e) {
      Logger.error('Ошибка подключения к WebSocket', e);
      rethrow;
    } finally {
      _timeoutTimer?.cancel();
      _channel?.sink.close();
    }
  }
}
