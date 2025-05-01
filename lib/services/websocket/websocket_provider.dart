import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/models/websocket/websocket_event.dart';
import 'websocket_service.dart';

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final webSocketEventsProvider = StreamProvider<WebSocketEvent>((ref) {
  final service = ref.watch(webSocketServiceProvider);
  return service.events;
});
