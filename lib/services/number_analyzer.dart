import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/utils/logger.dart';

class NumberAnalyzer {
  static const int _numbersToAnalyze = 9;

  List<Signal> detectMissingDozenOrRow(List<int> numbers) {
    if (numbers.length < _numbersToAnalyze) {
      Logger.warning('Недостаточно чисел для анализа: ${numbers.length}');
      return [];
    }

    final lastNumbers = numbers.take(_numbersToAnalyze).toList();
    final signals = <Signal>[];

    // Проверяем дюжины
    final dozens = _checkDozens(lastNumbers);
    if (dozens.isNotEmpty) {
      signals.add(Signal(
        type: SignalType.missingDozen,
        message:
            'Не выпадала ${dozens.join(", ")} дюжина в последних $_numbersToAnalyze числах',
        lastNumbers: lastNumbers,
        timestamp: DateTime.now(),
      ));
    }

    // Проверяем строки
    final rows = _checkRows(lastNumbers);
    if (rows.isNotEmpty) {
      signals.add(Signal(
        type: SignalType.missingRow,
        message:
            'Не выпадала ${rows.join(", ")} строка в последних $_numbersToAnalyze числах',
        lastNumbers: lastNumbers,
        timestamp: DateTime.now(),
      ));
    }

    return signals;
  }

  List<String> _checkDozens(List<int> numbers) {
    final missingDozens = <String>[];
    final dozen1 = numbers.where((n) => n >= 1 && n <= 12).isEmpty;
    final dozen2 = numbers.where((n) => n >= 13 && n <= 24).isEmpty;
    final dozen3 = numbers.where((n) => n >= 25 && n <= 36).isEmpty;

    if (dozen1) missingDozens.add('1-я');
    if (dozen2) missingDozens.add('2-я');
    if (dozen3) missingDozens.add('3-я');

    return missingDozens;
  }

  List<String> _checkRows(List<int> numbers) {
    final missingRows = <String>[];
    final row1 = numbers.where((n) => n % 3 == 1).isEmpty;
    final row2 = numbers.where((n) => n % 3 == 2).isEmpty;
    final row3 = numbers.where((n) => n % 3 == 0).isEmpty;

    if (row1) missingRows.add('1-я');
    if (row2) missingRows.add('2-я');
    if (row3) missingRows.add('3-я');

    return missingRows;
  }
}
