import 'dart:async';
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/services/number_analyzer.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/services/websocket_service.dart';
import 'package:roulette_signals/utils/logger.dart';

class RoulettesPoller {
  final RouletteService _rouletteService;
  final WebSocketService _webSocketService;
  final NumberAnalyzer _numberAnalyzer;
  Timer? _timer;
  bool _isRunning = false;
  int _currentIndex = 0;
  List<RouletteGame> _games = [];
  Duration _pollInterval;
  final Function(String, List<int>) onSignalDetected;
  DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(milliseconds: 100);

  RoulettesPoller({
    required this.onSignalDetected,
    Duration? pollInterval,
    RouletteService? rouletteService,
    WebSocketService? webSocketService,
    NumberAnalyzer? numberAnalyzer,
  })  : _pollInterval = pollInterval ?? const Duration(seconds: 30),
        _rouletteService = rouletteService ?? RouletteService(),
        _webSocketService = webSocketService ?? WebSocketService(),
        _numberAnalyzer = numberAnalyzer ?? NumberAnalyzer();

  Future<void> start() async {
    if (_isRunning) {
      Logger.warning('Пуллер уже запущен');
      return;
    }

    try {
      _games = await _rouletteService.fetchLiveRouletteGames();
      if (_games.isEmpty) {
        Logger.warning('Нет доступных рулеток для анализа');
        return;
      }

      _isRunning = true;
      _currentIndex = 0;
      _lastUpdateTime = DateTime.now();
      _startTimer();
      Logger.info(
          'Пуллер запущен с интервалом ${_pollInterval.inSeconds} секунд');
    } catch (e) {
      Logger.error('Ошибка запуска пуллера', e);
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _lastUpdateTime = null;
    Logger.info('Пуллер остановлен');
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) {
      if (_isRunning) {
        _analyzeNextGame();
      }
    });
  }

  Future<void> _analyzeNextGame() async {
    if (!_isRunning || _games.isEmpty) return;

    // Проверяем минимальный интервал между обновлениями
    final now = DateTime.now();
    if (_lastUpdateTime != null &&
        now.difference(_lastUpdateTime!) < _minUpdateInterval) {
      return;
    }
    _lastUpdateTime = now;

    final game = _games[_currentIndex];
    Logger.info('Анализ рулетки: ${game.title}');

    try {
      final params = await _rouletteService.extractWebSocketParams(game);
      if (params == null) {
        Logger.warning('Не удалось получить параметры для ${game.title}');
        return;
      }

      final results = await _webSocketService.fetchRecentResults(params);
      if (results == null) {
        Logger.warning('Не удалось получить результаты для ${game.title}');
        return;
      }

      final signals = _numberAnalyzer.detectMissingDozenOrRow(results.numbers);
      if (signals.isNotEmpty && _isRunning) {
        Logger.info(
            'Обнаружен сигнал для ${game.title}: ${signals.first.message}');
        onSignalDetected(game.title, results.numbers);
      }
    } catch (e) {
      Logger.error('Ошибка анализа ${game.title}', e);
    }

    _currentIndex = (_currentIndex + 1) % _games.length;
  }

  void updateInterval(Duration newInterval) {
    if (newInterval == _pollInterval) return;

    _pollInterval = newInterval;
    if (_isRunning) {
      _startTimer();
      Logger.info('Интервал обновлен до ${newInterval.inSeconds} секунд');
    }
  }

  bool get isRunning => _isRunning;
  Duration get pollInterval => _pollInterval;
}
