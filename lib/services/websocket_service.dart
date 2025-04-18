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
      // Получаем и формируем строку куки
      final prefs = await SharedPreferences.getInstance();
      String savedCookies = prefs.getString('all_cookies') ?? '';
      if (!savedCookies.contains('EVOSESSIONID=')) {
        savedCookies += '; EVOSESSIONID=${params.evoSessionId}';
      }
      Logger.debug('WS cookies: $savedCookies');

      // Подключаемся к WebSocket с заголовками
      final uri = Uri.parse(params.webSocketUrl);
      final headers = {
        'Cookie': savedCookies,
        'Origin': 'https://royal.evo-games.com',
      };
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: headers,
      );
      Logger.info('Connecting to WS with headers: $headers');

      final completer = Completer<RecentResults?>();
      _timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          Logger.warning('Таймаут получения результатов');
          completer.complete(null);
          _channel?.sink.close();
        }
      });

      _channel?.stream.listen(
        (data) {
          Logger.debug('Получены данные: $data');
          try {
            final results = RecentResults.fromJson(data);
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
      Logger.error('Ошибка получения результатов', e);
      return null;
    } finally {
      _timeoutTimer?.cancel();
      _channel?.sink.close();
    }
  }
}
