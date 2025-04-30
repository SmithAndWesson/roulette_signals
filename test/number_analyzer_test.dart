import 'package:flutter_test/flutter_test.dart';
import 'package:roulette_signals/services/number_analyzer.dart';
import 'package:roulette_signals/models/signal.dart';

void main() {
  test(
      'NumberAnalyzer должен обнаруживать паттерн 9 уникальных чисел в дюжине с разделителями',
      () {
    final analyzer = NumberAnalyzer();

    // Создаем список из 60 чисел, где в первой дюжине есть 9 уникальных чисел,
    // разделенных числами из других дюжин
    final numbers = [
      // 18 чисел: 9 наших + 9 разделителей
      1, 14, 2, 14, 3, 14, 4, 14, 5, 14,
      6, 14, 7, 14, 8, 14, 9, 14,
      // добиваем до 60 любыми, но так чтоб не вызвать новый шаблон
      15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
      25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
      35, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]; // итого 60

    final signals = analyzer.detectMissingDozenOrRow(numbers);

    expect(signals.first.type, SignalType.patternDozen9);
    expect(signals.first.message, contains('1-я дюжина'));
    expect(signals.first.message, contains('1, 2, 3, 4, 5, 6, 7, 8, 9'));
  });

  test(
      'NumberAnalyzer должен обнаруживать паттерн 9 уникальных чисел в строке с разделителями',
      () {
    final analyzer = NumberAnalyzer();

    // Создаем список из 60 чисел, где в первом ряду есть 9 уникальных чисел,
    // разделенных числами из других рядов
    final numbers = [
      // Первый ряд (1,4,7,10,13,16,19,22,25,28,31,34) с разделителями
      1, 2, 4, 3, 7, 2, 10, 3, 13, 2, 16, 3, 19, 2, 22, 3, 25, 2, 28, 3, 31, 2,
      34, 3,
      // Остальные числа для заполнения до 60
      2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 17, 18,
      20, 21, 23, 24, 26, 27, 29, 30, 32, 33, 35, 36,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ];

    final signals = analyzer.detectMissingDozenOrRow(numbers);

    expect(signals.first.type, SignalType.patternRow9);
    expect(signals.first.message, contains('1-й ряд'));
  });
}
