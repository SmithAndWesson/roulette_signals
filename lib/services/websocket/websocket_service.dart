import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:roulette_signals/core/constants/app_constants.dart';
import 'package:roulette_signals/models/websocket/websocket_event.dart';
import 'package:roulette_signals/models/websocket/websocket_message.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:roulette_signals/services/session/session_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/models/recent_results.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final _eventController = StreamController<WebSocketEvent>.broadcast();
  Timer? _reconnectTimer;
  bool _isConnecting = false;

  Stream<WebSocketEvent> get events => _eventController.stream;

  Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      Logger.info('Подключение к WebSocket');
      _channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.wsBaseUrl),
      );

      _channel!.stream.listen(
        (data) => _handleMessage(data),
        onError: (error) {
          Logger.error('Ошибка WebSocket', error);
          _eventController.add(WebSocketEvent.error(error.toString()));
          _scheduleReconnect();
        },
        onDone: () {
          Logger.info('WebSocket соединение закрыто');
          _eventController.add(WebSocketEvent.disconnected());
          _scheduleReconnect();
        },
      );

      _eventController.add(WebSocketEvent.connected());
      Logger.info('WebSocket подключен');
    } catch (e) {
      Logger.error('Ошибка подключения к WebSocket', e);
      _eventController.add(WebSocketEvent.error(e.toString()));
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final message = WebSocketMessage.fromJson(data as Map<String, dynamic>);

      if (message.isRecentResults && message.recentNumbers != null) {
        _eventController
            .add(WebSocketEvent.recentNumbers(message.recentNumbers!));
      } else if (message.isNewNumber && message.newNumber != null) {
        _eventController.add(WebSocketEvent.newNumber(message.newNumber!));
      }
    } catch (e) {
      Logger.error('Ошибка обработки сообщения WebSocket', e);
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(seconds: AppConstants.wsTimeoutSeconds),
      () => connect(),
    );
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
    Logger.info('WebSocket отключен');
  }

  Future<void> dispose() async {
    await disconnect();
    await _eventController.close();
  }

  Future<RecentResults?> fetchRecentResults(WebSocketParams params) async {
    try {
      // Здесь должна быть реализация получения последних результатов через WebSocket
      // Пока возвращаем заглушку
      return RecentResults(numbers: []);
    } catch (e) {
      Logger.error('Ошибка получения результатов', e);
      return null;
    }
  }
}
