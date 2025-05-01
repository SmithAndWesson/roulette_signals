import 'roulette_number.dart';

class RouletteStats {
  final List<RouletteNumber> recentNumbers;
  final Map<String, int> colorCounts;
  final Map<String, int> parityCounts;
  final Map<String, int> rangeCounts;

  const RouletteStats({
    required this.recentNumbers,
    required this.colorCounts,
    required this.parityCounts,
    required this.rangeCounts,
  });

  factory RouletteStats.fromNumbers(List<RouletteNumber> numbers) {
    final colorCounts = <String, int>{'red': 0, 'black': 0, 'green': 0};
    final parityCounts = <String, int>{'even': 0, 'odd': 0};
    final rangeCounts = <String, int>{'high': 0, 'low': 0};

    for (final number in numbers) {
      colorCounts[number.color] = (colorCounts[number.color] ?? 0) + 1;
      parityCounts[number.isEven ? 'even' : 'odd'] =
          (parityCounts[number.isEven ? 'even' : 'odd'] ?? 0) + 1;
      rangeCounts[number.isHigh ? 'high' : 'low'] =
          (rangeCounts[number.isHigh ? 'high' : 'low'] ?? 0) + 1;
    }

    return RouletteStats(
      recentNumbers: numbers,
      colorCounts: colorCounts,
      parityCounts: parityCounts,
      rangeCounts: rangeCounts,
    );
  }

  double get redPercentage => colorCounts['red']! / recentNumbers.length;
  double get blackPercentage => colorCounts['black']! / recentNumbers.length;
  double get greenPercentage => colorCounts['green']! / recentNumbers.length;
  double get evenPercentage => parityCounts['even']! / recentNumbers.length;
  double get oddPercentage => parityCounts['odd']! / recentNumbers.length;
  double get highPercentage => rangeCounts['high']! / recentNumbers.length;
  double get lowPercentage => rangeCounts['low']! / recentNumbers.length;

  @override
  String toString() => 'RouletteStats(recentNumbers: ${recentNumbers.length})';
}
