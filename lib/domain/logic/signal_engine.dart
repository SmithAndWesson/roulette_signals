import 'package:roulette_signals/models/game_models.dart';

class SignalEngine {
  final List<RouletteNumber> _numbers = [];
  final int _signalThreshold = 9;
  final Function(Signal) onSignalDetected;

  SignalEngine({
    required this.onSignalDetected,
  });

  void addNumber(RouletteNumber number) {
    _numbers.add(number);
    _checkSignals();
  }

  void _checkSignals() {
    _checkDozenSignals();
    _checkColumnSignals();
  }

  void _checkDozenSignals() {
    for (var dozen = 1; dozen <= 3; dozen++) {
      final lastIndex = _findLastDozenIndex(dozen);
      if (lastIndex != -1) {
        final missingRounds = _numbers.length - lastIndex - 1;
        if (missingRounds >= _signalThreshold) {
          final lastNumbers = _numbers.sublist(
            _numbers.length - _signalThreshold,
            _numbers.length,
          ).map((n) => n.number).toList();

          onSignalDetected(Signal(
            type: 'dozen',
            number: dozen,
            missingRounds: missingRounds,
            lastNumbers: lastNumbers,
          ));
        }
      }
    }
  }

  void _checkColumnSignals() {
    for (var column = 1; column <= 3; column++) {
      final lastIndex = _findLastColumnIndex(column);
      if (lastIndex != -1) {
        final missingRounds = _numbers.length - lastIndex - 1;
        if (missingRounds >= _signalThreshold) {
          final lastNumbers = _numbers.sublist(
            _numbers.length - _signalThreshold,
            _numbers.length,
          ).map((n) => n.number).toList();

          onSignalDetected(Signal(
            type: 'column',
            number: column,
            missingRounds: missingRounds,
            lastNumbers: lastNumbers,
          ));
        }
      }
    }
  }

  int _findLastDozenIndex(int dozen) {
    for (var i = _numbers.length - 1; i >= 0; i--) {
      if (_numbers[i].dozen == dozen) {
        return i;
      }
    }
    return -1;
  }

  int _findLastColumnIndex(int column) {
    for (var i = _numbers.length - 1; i >= 0; i--) {
      if (_numbers[i].column == column) {
        return i;
      }
    }
    return -1;
  }

  void clear() {
    _numbers.clear();
  }
} 