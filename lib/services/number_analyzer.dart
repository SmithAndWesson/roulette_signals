import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/utils/logger.dart';

class NumberAnalyzer {
  static const int _numbersToAnalyze = 300; //9

//detectPattern9
  List<Signal> detectMissingDozenOrRow(List<int> numbers) {
    if (numbers.length < _numbersToAnalyze) return [];

    final slice = numbers.take(_numbersToAnalyze).toList();
    final result = <Signal>[];

    // проверка дюжин
    for (var dz = 0; dz < 3; dz++) {
      final uniq = <int>{};
      var lastOur = false;
      for (final n in slice) {
        final isOur = _dozen(n) == dz;
        if (isOur) {
          if (lastOur) {
            uniq.clear();
            lastOur = false;
            continue;
          } // два подряд  → не подходит
          uniq.add(n);
        }
        lastOur = isOur;
        if (uniq.length >= 9) {
          result.add(_buildDozenSignal(dz, uniq, slice));
          break; // если нужен только один сигнал за проход
        }
      }
    }

    // проверка строк
    for (var col = 0; col < 3; col++) {
      final uniq = <int>{};
      var lastOur = false;
      for (final n in slice) {
        final isOur = _column(n) == col;
        if (isOur) {
          if (lastOur) {
            uniq.clear();
            lastOur = false;
            continue;
          }
          uniq.add(n);
        }
        lastOur = isOur;
      }
      if (uniq.length >= 9) {
        result.add(_buildColumnSignal(col, uniq, slice));
        break;
      }
    }
    return result;
  }

  int _dozen(int n) => (n - 1) ~/ 12; // 0,1,2
  int _column(int n) => (n - 1) % 3; // 0,1,2

  Signal _buildDozenSignal(int dozen, Set<int> uniq, List<int> lastNums) {
    final dozenLabel = '${dozen + 1}-я дюжина'; // 1-я, 2-я, 3-я
    return Signal(
      type: SignalType.patternDozen9,
      message:
          'Шаблон 9 уникальных ($dozenLabel): ${uniq.join(", ")}', // <- текст
      lastNumbers: lastNums,
      timestamp: DateTime.now(),
    );
  }

  Signal _buildColumnSignal(int col, Set<int> uniq, List<int> lastNums) {
    final colLabel = '${col + 1}-й ряд'; // 1-й, 2-й, 3-й
    return Signal(
      type: SignalType.patternRow9,
      message: 'Шаблон 9 уникальных ($colLabel): ${uniq.join(", ")}',
      lastNumbers: lastNums,
      timestamp: DateTime.now(),
    );
  }
}
