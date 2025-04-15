enum SignalType {
  missingDozen,
  missingRow,
}

class Signal {
  final SignalType type;
  final String message;
  final List<int> lastNumbers;
  final DateTime timestamp;

  Signal({
    required this.type,
    required this.message,
    required this.lastNumbers,
    required this.timestamp,
  });
}
