class RouletteGame {
  final String title;
  final String provider;
  final String identifier;
  final String playUrl;
  final String id;
  final String slug;
  final List<String> collections;
  bool isAnalyzing;

  RouletteGame({
    required this.title,
    required this.provider,
    required this.identifier,
    required this.playUrl,
    required this.id,
    required this.slug,
    required this.collections,
    this.isAnalyzing = false,
  });

  factory RouletteGame.fromJson(Map<String, dynamic> json) {
    return RouletteGame(
      title: json['title'] as String,
      provider: json['provider'] as String,
      identifier: json['identifier'] as String,
      playUrl: json['play_url']?['UAH'] ?? '',
      id: json['id'].toString(),
      slug: json['slug'] as String,
      collections: List<String>.from(json['collections']),
    );
  }
}
