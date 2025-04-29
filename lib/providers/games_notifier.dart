import 'package:flutter/foundation.dart';
import 'package:roulette_signals/models/roulette_game.dart';

class GamesNotifier extends ChangeNotifier {
  final List<RouletteGame> _games = [];
  String _selectedProvider = 'All';

  List<RouletteGame> get games => List.unmodifiable(_games);
  String get selectedProvider => _selectedProvider;

  void setGames(List<RouletteGame> games) {
    _games.clear();
    _games.addAll(games);
    notifyListeners();
  }

  void setAnalyzing(String id, bool value) {
    try {
      final game = _games.firstWhere((g) => g.id == id);
      if (game.isAnalyzing != value) {
        game.isAnalyzing = value;
        notifyListeners();
      }
    } catch (e) {
      // Игра не найдена, игнорируем
    }
  }

  void forceSelect(String provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  /// Снять флаг анализа у всех игр и уведомить слушателей.
  void clearAllAnalyzing() {
    for (final g in _games) {
      g.isAnalyzing = false;
    }
    notifyListeners(); // ✅ вызов внутри класса — разрешён
  }
}
