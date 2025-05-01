import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/session/session_manager.dart';
import 'package:roulette_signals/services/websocket/websocket_service.dart';
import 'package:roulette_signals/services/number_analyzer.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/services/webview/webview_service.dart';
import '../../services/roulettes_poller.dart';
import 'package:roulette_signals/providers/roulettes_poller_provider.dart';

// Провайдеры для сервисов
final sessionManagerProvider =
    Provider<SessionManager>((ref) => SessionManager());

final webViewServiceProvider = Provider<WebViewService>((ref) {
  final service = WebViewService();
  ref.onDispose(() => service.dispose());
  return service;
});

final rouletteServiceProvider = Provider<RouletteService>((ref) {
  return RouletteService();
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final numberAnalyzerProvider = Provider<NumberAnalyzer>((ref) {
  return NumberAnalyzer();
});

final roulettesPollerProvider =
    StateNotifierProvider<RoulettesPollerNotifier, RoulettesPollerState>((ref) {
  return RoulettesPollerNotifier(
    rouletteService: ref.read(rouletteServiceProvider),
    webSocketService: ref.read(webSocketServiceProvider),
    numberAnalyzer: ref.read(numberAnalyzerProvider),
  );
});
