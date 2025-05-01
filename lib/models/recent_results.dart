class RecentResults {
  final List<int> numbers;
  final DateTime timestamp;

  RecentResults({
    required this.numbers,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory RecentResults.fromJson(Map<String, dynamic> json) {
    // final args = json['args'];
    // if (json['type'] != 'roulette.recentResults' || args is! Map) {
    //   throw FormatException('Not recentResults');
    // }

    // final List<dynamic> numbersJson = json['recentResults'] as List;
    // return RecentResults(
    //   numbers: numbersJson.map((n) => n as int).toList(),
    //   timestamp: DateTime.now(),
    // );
    final args = json['args'] as Map<String, dynamic>;
    final raw = args['recentResults'] as List? ?? [];

    final numbers = raw
        .whereType<List>()
        .take(9)
        .map((e) => e.first as String)
        .map((s) => s.split('x').first)
        .map(int.parse)
        .toList();

    return RecentResults(numbers: numbers, timestamp: DateTime.now());
  }
}
