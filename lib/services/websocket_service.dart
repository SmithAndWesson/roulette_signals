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

      final sub = _channel!.stream.listen(
        (message) {
          Logger.debug('WS ⇠ $message');

          // 1️⃣ Пробуем декодировать JSON
          Map<String, dynamic>? decoded;
          try {
            final tmp = jsonDecode(message);
            if (tmp is Map<String, dynamic>) decoded = tmp;
          } on FormatException {
            // это пинг‑строка или просто мусор – пропускаем
            return;
          }

          if (decoded == null) return; // не карта – пропускаем
          if (decoded['type'] != 'roulette.recentResults') return;

          // 2️⃣ Есть нужное событие – пытаемся распарсить
          try {
            final results = RecentResults.fromJson(decoded);
            if (!completer.isCompleted) {
              completer.complete(results);
            }
            // если нужен только ПЕРВЫЙ recentResults – можно тут же unsub:
            // sub.cancel();
          } catch (e, st) {
            Logger.error('Не смог распарсить recentResults', e);
          }
        },
        onError: (error, st) {
          Logger.error('Ошибка WebSocket', error);
          if (!completer.isCompleted) completer.complete(null);
        },
        onDone: () {
          Logger.info('WebSocket закрыт');
          if (!completer.isCompleted) completer.complete(null);
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
