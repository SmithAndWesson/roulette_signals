class RecentResults {
  final List<int> numbers;
  final DateTime timestamp;

  RecentResults({
    required this.numbers,
    required this.timestamp,
  });

  factory RecentResults.fromJson(Map<String, dynamic> json) {
    final args = json['args'];
    if (json['type'] != 'roulette.recentResults' || args is! Map) {
      throw FormatException('Not recentResults');
    }

    final List<dynamic> numbersJson = json['recentResults'] as List;
    return RecentResults(
      numbers: numbersJson.map((n) => n as int).toList(),
      timestamp: DateTime.now(),
    );
  }
}
