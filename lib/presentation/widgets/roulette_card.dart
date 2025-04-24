import 'package:flutter/material.dart';
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class RouletteCard extends StatelessWidget {
  final RouletteGame game;
  final String evoSessionId;
  final Function(WebSocketParams) onConnect;
  final List<Signal> signals;
  final bool isAnalyzing;
  final List<int> recentNumbers;

  const RouletteCard({
    Key? key,
    required this.game,
    required this.evoSessionId,
    required this.onConnect,
    this.signals = const [],
    this.isAnalyzing = false,
    this.recentNumbers = const [],
  }) : super(key: key);

  Color _chipColor(int n) => n == 0
      ? Colors.green
      : n <= 18
          ? Colors.red
          : Colors.black;

  Future<void> _launchGame() async {
    final gamePageUrl = 'https://gizbo.casino${game.playUrl}';
    try {
      final uri = Uri.parse(gamePageUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        // Пробуем альтернативный способ
        await launch(gamePageUrl);
      }
    } catch (e) {
      Logger.error('Ошибка при открытии ссылки: $gamePageUrl', e);
    }
  }

  Future<void> _connectToGame() async {
    try {
      Logger.info('Подключение к рулетке: ${game.title}');
      final params = await RouletteService().extractWebSocketParams(game);
      if (params != null) {
        onConnect(params);
      }
    } catch (e) {
      Logger.error('Ошибка подключения к рулетке', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          await _launchGame();
          await _connectToGame();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                game.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                game.provider,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (isAnalyzing) ...[
                const SizedBox(height: 8),
                const Text(
                  'Анализ',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              if (signals.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...signals.map((signal) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        signal.message,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    )),
              ],
              if (recentNumbers.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: recentNumbers.take(9).map((n) {
                    final bg = _chipColor(n);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$n',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
