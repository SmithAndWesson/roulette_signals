import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/roulettes_poller.dart';
import '../services/roulette_service.dart';
import 'package:roulette_signals/services/websocket/websocket_service.dart';
import '../services/number_analyzer.dart';
import '../utils/logger.dart';
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/core/di/service_locator.dart';

class RoulettesPollerState {
  final List<RouletteGame> games;
  final Map<String, List<int>> recentNumbers;
  final Map<String, List<Signal>> gameSignals;
  final bool isAnalyzing;
  final String? currentAnalyzingGameId;
  final Duration analysisInterval;

  const RoulettesPollerState({
    this.games = const [],
    this.recentNumbers = const {},
    this.gameSignals = const {},
    this.isAnalyzing = false,
    this.currentAnalyzingGameId,
    this.analysisInterval = const Duration(seconds: 1),
  });

  RoulettesPollerState copyWith({
    List<RouletteGame>? games,
    Map<String, List<int>>? recentNumbers,
    Map<String, List<Signal>>? gameSignals,
    bool? isAnalyzing,
    String? currentAnalyzingGameId,
    Duration? analysisInterval,
  }) {
    return RoulettesPollerState(
      games: games ?? this.games,
      recentNumbers: recentNumbers ?? this.recentNumbers,
      gameSignals: gameSignals ?? this.gameSignals,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      currentAnalyzingGameId:
          currentAnalyzingGameId ?? this.currentAnalyzingGameId,
      analysisInterval: analysisInterval ?? this.analysisInterval,
    );
  }
}

class RoulettesPollerNotifier extends StateNotifier<RoulettesPollerState> {
  final RouletteService _rouletteService;
  final WebSocketService _webSocketService;
  final NumberAnalyzer _numberAnalyzer;

  RoulettesPollerNotifier({
    required RouletteService rouletteService,
    required WebSocketService webSocketService,
    required NumberAnalyzer numberAnalyzer,
  })  : _rouletteService = rouletteService,
        _webSocketService = webSocketService,
        _numberAnalyzer = numberAnalyzer,
        super(const RoulettesPollerState());

  Future<void> loadGames() async {
    try {
      final games = await _rouletteService.fetchLiveRouletteGames();
      state = state.copyWith(games: games);
    } catch (e) {
      // Обработка ошибок
    }
  }

  void toggleAnalysis() {
    final isAnalyzing = !state.isAnalyzing;
    state = state.copyWith(isAnalyzing: isAnalyzing);

    if (isAnalyzing) {
      startAnalysis();
    } else {
      stopAnalysis();
    }
  }

  void updateAnalysisInterval(Duration interval) {
    state = state.copyWith(analysisInterval: interval);
  }

  Future<void> startAnalysis() async {
    if (!state.isAnalyzing) return;

    try {
      final evolutionGames =
          state.games.where((game) => game.provider == 'evolution').toList();

      for (final game in evolutionGames) {
        if (!state.isAnalyzing) break;

        state = state.copyWith(currentAnalyzingGameId: game.id);

        final params = await _rouletteService.extractWebSocketParams(game);
        if (params == null) continue;

        final results = await _webSocketService.fetchRecentResults(params);
        if (results == null) continue;

        final numbers = results.numbers;
        final signals = _numberAnalyzer.detectMissingDozenOrRow(numbers);

        state = state.copyWith(
          recentNumbers: {...state.recentNumbers, game.id: numbers},
          gameSignals: {...state.gameSignals, game.id: signals},
        );
      }
    } finally {
      state = state.copyWith(currentAnalyzingGameId: null);
    }
  }

  void stopAnalysis() {
    state = state.copyWith(
      isAnalyzing: false,
      currentAnalyzingGameId: null,
      gameSignals: {},
      recentNumbers: {},
    );
  }
}

final roulettesPollerProvider =
    StateNotifierProvider<RoulettesPollerNotifier, RoulettesPollerState>((ref) {
  final rouletteService = ref.watch(rouletteServiceProvider);
  final webSocketService = ref.watch(webSocketServiceProvider);
  final numberAnalyzer = ref.watch(numberAnalyzerProvider);

  return RoulettesPollerNotifier(
    rouletteService: rouletteService,
    webSocketService: webSocketService,
    numberAnalyzer: numberAnalyzer,
  );
});
