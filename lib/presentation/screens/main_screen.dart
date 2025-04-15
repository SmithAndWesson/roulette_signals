import 'package:flutter/material.dart';
import 'package:roulette_signals/data/telegram/telegram_service.dart';
import 'package:roulette_signals/data/websocket/lobby_socket.dart';
import 'package:roulette_signals/data/websocket/table_socket.dart';
import 'package:roulette_signals/domain/logic/signal_engine.dart';
import 'package:roulette_signals/models/game_models.dart'
    show RouletteNumber, AuthResponse;
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
  late LobbySocket _lobbySocket;
  late TableSocket _tableSocket;
  late SignalEngine _signalEngine;
  late TelegramService _telegramService;
  late RoulettesPoller _roulettesPoller;
  final _soundPlayer = SoundPlayer();
  final List<RouletteNumber> _numbers = [];
  final List<Signal> _signals = [];
  final _rouletteService = RouletteService();
  final _webSocketService = WebSocketService();
  final _numberAnalyzer = NumberAnalyzer();
  List<RouletteGame> _games = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;
  Map<String, RecentResults?> _recentResults = {};
  Map<String, List<Signal>> _gameSignals = {};
  Duration _analysisInterval = const Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadGames();
  }

  void _initializeServices() {
    _telegramService = TelegramService(
      botToken: 'YOUR_BOT_TOKEN', // Замените на реальный токен
      chatId: 'YOUR_CHAT_ID', // Замените на реальный chat_id
    );

    _signalEngine = SignalEngine(
      onSignalDetected: _handleSignal,
    );

    _lobbySocket = LobbySocket(
      sessionId: widget.authResponse.evoSessionId,
      onNumbersReceived: _handleNumbers,
    );

    _tableSocket = TableSocket(
      tableId: 'YOUR_TABLE_ID', // Замените на реальный ID стола
      evoSessionId: widget.authResponse.evoSessionId,
      onNumberReceived: _handleNumber,
    );

    _roulettesPoller = RoulettesPoller(
      onSignalDetected: _handlePollerSignal,
      pollInterval: _analysisInterval,
    );

    _lobbySocket.connect();
    _tableSocket.connect();
  }

  Future<void> _loadGames() async {
    try {
      final games = await _rouletteService.fetchLiveRouletteGames();
      setState(() {
        _games = games;
        _isLoading = false;
      });
    } catch (e) {
      Logger.error('Ошибка загрузки списка рулеток', e);
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка загрузки списка рулеток'),
          ),
        );
      }
    }
  }

  void _handleNumbers(List<RouletteNumber> numbers) {
    setState(() {
      _numbers.addAll(numbers);
    });
  }

  void _handleNumber(RouletteNumber number) {
    setState(() {
      _numbers.add(number);
    });
    _signalEngine.addNumber(number);
  }

  void _handleSignal(Signal signal) async {
    setState(() {
      _signals.add(signal);
    });

    // Воспроизведение звука
    await _soundPlayer.playPing();

    // Отправка в Telegram
    try {
      await _telegramService.sendSignal(signal);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка отправки в Telegram: $e')),
        );
      }
    }

    // Показ уведомления
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(signal.message),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _handlePollerSignal(String gameTitle, List<int> numbers) {
    final signals = _numberAnalyzer.detectMissingDozenOrRow(numbers);
    if (signals.isNotEmpty) {
      setState(() {
        _gameSignals[gameTitle] = signals;
      });
      _handleSignals(gameTitle, signals);
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
      final results = await _webSocketService.fetchRecentResults(params);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список рулеток'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadGames,
          ),
          IconButton(
            icon: Icon(_isAnalyzing ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleAnalysis,
            tooltip: _isAnalyzing ? 'Остановить анализ' : 'Запустить анализ',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _games.length,
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      return RouletteCard(
                        game: game,
                        evoSessionId: widget.authResponse.evoSessionId,
                        onConnect: (params) {
                          Logger.info('Подключение к рулетке: ${game.title}');
                          _fetchRecentResults(game.id.toString(), params);
                        },
                        signals: _gameSignals[game.title] ?? [],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _lobbySocket.disconnect();
    _tableSocket.disconnect();
    _roulettesPoller.stop();
    _soundPlayer.dispose();
    super.dispose();
  }
}
