import 'roulette_number.dart';

class RouletteSignal {
  final RouletteNumber number;
  final DateTime timestamp;
  final String gameId;
  final String provider;

  const RouletteSignal({
    required this.number,
    required this.timestamp,
    required this.gameId,
    required this.provider,
  });

  factory RouletteSignal.fromJson(Map<String, dynamic> json) {
    return RouletteSignal(
      number: RouletteNumber.fromValue(json['number'] as int),
      timestamp: DateTime.parse(json['timestamp'] as String),
      gameId: json['gameId'] as String,
      provider: json['provider'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number.value,
      'timestamp': timestamp.toIso8601String(),
      'gameId': gameId,
      'provider': provider,
    };
  }

  @override
  String toString() => 'RouletteSignal(number: $number, gameId: $gameId)';
}
