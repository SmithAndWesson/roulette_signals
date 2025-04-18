import 'package:flutter/material.dart';
import 'package:roulette_signals/models/game_models.dart' show AuthResponse;
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/recent_results.dart';
import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/presentation/widgets/roulette_card.dart';
import 'package:roulette_signals/services/number_analyzer.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/services/roulettes_poller.dart';
import 'package:roulette_signals/services/websocket_service.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:roulette_signals/utils/sound_player.dart';

class MainScreen extends StatefulWidget {
  final AuthResponse authResponse;

  const MainScreen({
    Key? key,
    required this.authResponse,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _rouletteService = RouletteService();
  final _websocketService = WebSocketService();
  final _numberAnalyzer = NumberAnalyzer();
  final _soundPlayer = SoundPlayer();
  List<RouletteGame> _games = [];
  String _selectedProvider = 'All';
  List<String> _allProviders = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;
  DateTime? _lastAnalysisTime;
  Map<String, RecentResults?> _recentResults = {};
  Map<String, List<Signal>> _gameSignals = {};
  Duration _analysisInterval = const Duration(seconds: 30);
  late final RoulettesPoller _roulettesPoller;

  @override
  void initState() {
    super.initState();
    _roulettesPoller = RoulettesPoller(
      onSignalDetected: _handlePollerSignal,
      pollInterval: _analysisInterval,
    );
    _loadGames();
  }

  Future<void> _loadGames() async {
    try {
      setState(() => _isLoading = true);
      final games = await _rouletteService.fetchLiveRouletteGames();
      setState(() {
        _games = games;
        _allProviders = games.map((g) => g.provider).toSet().toList()..sort();
        _isLoading = false;
      });
    } catch (e) {
      Logger.error('Ошибка загрузки игр', e);
      setState(() => _isLoading = false);
    }
  }

  void _toggleAnalysis() {
    setState(() {
      _isAnalyzing = !_isAnalyzing;
      if (_isAnalyzing) {
        _roulettesPoller.start();
      } else {
        _roulettesPoller.stop();
      }
    });
  }

  void _updateAnalysisInterval(Duration interval) {
    setState(() {
      _analysisInterval = interval;
      _roulettesPoller.updateInterval(interval);
    });
  }

  Future<void> _fetchRecentResults(
      String gameId, WebSocketParams params) async {
    setState(() {
      _recentResults[gameId] = null;
    });

    try {
      final results = await _websocketService.fetchRecentResults(params);
      setState(() {
        _recentResults[gameId] = results;
      });

      if (results != null) {
        Logger.info('Получены результаты для $gameId: ${results.numbers}');
        _analyzeResults(gameId, results.numbers);
      } else {
        Logger.warning('Не удалось получить результаты для $gameId');
      }
    } catch (e) {
      Logger.error('Ошибка получения результатов для $gameId', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка получения результатов'),
          ),
        );
      }
    }
  }

  void _analyzeResults(String gameId, List<int> numbers) {
    final signals = _numberAnalyzer.detectMissingDozenOrRow(numbers);
    if (signals.isNotEmpty) {
      setState(() {
        _gameSignals[gameId] = signals;
      });
      _handleSignals(gameId, signals);
    }
  }

  void _handlePollerSignal(String gameTitle, List<int> numbers) {
    final signals = _numberAnalyzer.detectMissingDozenOrRow(numbers);
    if (signals.isNotEmpty) {
      final game = _games.firstWhere(
        (g) => g.title == gameTitle,
        orElse: () => RouletteGame(
          id: '0',
          title: gameTitle,
          provider: '',
          identifier: '',
          playUrl: '',
          slug: '',
          collections: [],
        ),
      );
      setState(() {
        _gameSignals[game.id] = signals;
      });
      _handleSignals(game.id, signals);
    }
  }

  Future<void> _handleSignals(String gameId, List<Signal> signals) async {
    for (final signal in signals) {
      // Воспроизведение звука
      await _soundPlayer.playPing();

      // Показ уведомления
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(signal.message),
            duration: const Duration(seconds: 5),
          ),
        );
      }

      Logger.info('Сигнал для $gameId: ${signal.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredGames = _games
        .where((game) =>
            _selectedProvider == 'All' || game.provider == _selectedProvider)
        .toList();

    // Создаем Map с количеством игр для каждого провайдера
    final providerCounts = <String, int>{};
    for (final game in _games) {
      providerCounts[game.provider] = (providerCounts[game.provider] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette Signals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadGames,
          ),
          IconButton(
            icon: Icon(_isAnalyzing ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleAnalysis,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Интервал анализа:'),
                  const SizedBox(width: 8),
                  DropdownButton<Duration>(
                    value: _analysisInterval,
                    items: const [
                      DropdownMenuItem(
                        value: Duration(seconds: 15),
                        child: Text('15 сек'),
                      ),
                      DropdownMenuItem(
                        value: Duration(seconds: 30),
                        child: Text('30 сек'),
                      ),
                      DropdownMenuItem(
                        value: Duration(seconds: 60),
                        child: Text('1 мин'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updateAnalysisInterval(value);
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedProvider,
                      items: [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All (${_games.length})'),
                        ),
                        ..._allProviders.map((provider) => DropdownMenuItem(
                              value: provider,
                              child: Text(
                                  '$provider (${providerCounts[provider] ?? 0})'),
                            )),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedProvider = value!),
                      isExpanded: true,
                      style: Theme.of(context).textTheme.bodyLarge,
                      dropdownColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.count(
                      crossAxisCount: 5,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      padding: const EdgeInsets.all(16.0),
                      children: filteredGames
                          .map((game) => RouletteCard(
                                game: game,
                                evoSessionId: widget.authResponse.evoSessionId,
                                onConnect: (params) => _fetchRecentResults(
                                    game.id.toString(), params),
                                signals: _gameSignals[game.id] ?? [],
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roulettesPoller.stop();
    _soundPlayer.dispose();
    super.dispose();
  }
}
