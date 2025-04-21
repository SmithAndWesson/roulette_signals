import 'package:flutter/material.dart';
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/signal.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/services/roulette_service.dart';
import 'package:roulette_signals/utils/logger.dart';

class RouletteCard extends StatelessWidget {
  final RouletteGame game;
  final String evoSessionId;
  final Function(WebSocketParams) onConnect;
  final List<Signal> signals;

  const RouletteCard({
    Key? key,
    required this.game,
    required this.evoSessionId,
    required this.onConnect,
    this.signals = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _connectToGame(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      game.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (signals.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${signals.length} сигнал${signals.length > 1 ? 'а' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                game.provider,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (signals.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...signals.map((signal) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        signal.message,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
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
}
