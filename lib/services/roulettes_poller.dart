import 'dart:async';
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/services/number_analyzer.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/services/websocket_service.dart';
import 'package:roulette_signals/utils/logger.dart';

class RoulettesPoller {
  final RouletteService _rouletteService;
  final WebSocketService _webSocketService;
  final NumberAnalyzer _numberAnalyzer;
  final Function(String, List<int>) onSignalDetected;
  final Function(String) onAnalysisStart;
  final Function(String) onAnalysisStop;
  Duration _pollInterval;
  Timer? _timer;
  bool _isRunning = false;
  bool _isAnalyzing = false; // Флаг для отслеживания состояния анализа
  DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(milliseconds: 100);
  int _currentIndex = 0;
  List<RouletteGame> _games = [];

  RoulettesPoller({
    required this.onSignalDetected,
    required this.onAnalysisStart,
    required this.onAnalysisStop,
    Duration? pollInterval,
    RouletteService? rouletteService,
    WebSocketService? webSocketService,
    NumberAnalyzer? numberAnalyzer,
  })  : _pollInterval = pollInterval ?? const Duration(seconds: 30),
        _rouletteService = rouletteService ?? RouletteService(),
        _webSocketService = webSocketService ?? WebSocketService(),
        _numberAnalyzer = numberAnalyzer ?? NumberAnalyzer() {
    if (pollInterval == null) {
      Logger.info('Используется интервал по умолчанию: 30 секунд');
    }
  }

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

      // Выполняем первый анализ сразу
      _analyzeNextGame();

      // Запускаем таймер для последующих анализов
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
    _isAnalyzing = false; // Сбрасываем флаг анализа
    _lastUpdateTime = null;
    _currentIndex = 0;
    Logger.info('Пуллер остановлен');
  }

  void updateInterval(Duration newInterval) {
    if (newInterval == _pollInterval) return;

    _pollInterval = newInterval;
    if (_isRunning) {
      _timer?.cancel();
      _startTimer();
      Logger.info('Интервал обновлен до ${newInterval.inSeconds} секунд');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) {
      if (_isRunning && !_isAnalyzing) {
        // Проверяем, что предыдущий анализ завершен
        _analyzeNextGame();
      }
    });
  }

  Future<void> _analyzeNextGame() async {
    if (!_isRunning || _games.isEmpty || _isAnalyzing)
      return; // Проверяем, что анализ не запущен

    _isAnalyzing = true; // Устанавливаем флаг начала анализа
    try {
      // Проверяем минимальный интервал между обновлениями
      final now = DateTime.now();
      if (_lastUpdateTime != null &&
          now.difference(_lastUpdateTime!) < _minUpdateInterval) {
        return;
      }
      _lastUpdateTime = now;

      // Получаем только рулетки Evolution
      final evolutionGames =
          _games.where((game) => game.provider == 'evolution').toList();
      if (evolutionGames.isEmpty) {
        _currentIndex = (_currentIndex + 1) % _games.length;
        return;
      }

      // Анализируем все рулетки Evolution по очереди
      for (final game in evolutionGames) {
        if (!_isRunning) break; // Прерываем если пуллер остановлен

        Logger.info('Анализ рулетки: ${game.title}');
        onAnalysisStart(game.id);

        try {
          final params = await _rouletteService.extractWebSocketParams(game);
          if (params == null) {
            Logger.warning('Не удалось получить параметры для ${game.title}');
            continue;
          }

          final results = await _webSocketService.fetchRecentResults(params);
          if (results == null) {
            Logger.warning('Не удалось получить результаты для ${game.title}');
            continue;
          }

          final signals =
              _numberAnalyzer.detectMissingDozenOrRow(results.numbers);
          if (signals.isNotEmpty && _isRunning) {
            Logger.info(
                'Обнаружен сигнал для ${game.title}: ${signals.first.message}');
            onSignalDetected(game.title, results.numbers);
          }
        } catch (e) {
          Logger.error('Ошибка анализа ${game.title}', e);
        } finally {
          onAnalysisStop(game.id);
        }
      }

      _currentIndex = (_currentIndex + 1) % evolutionGames.length;
    } finally {
      _isAnalyzing = false; // Сбрасываем флаг по завершении анализа
    }
  }

  bool get isRunning => _isRunning;
  Duration get pollInterval => _pollInterval;
}
