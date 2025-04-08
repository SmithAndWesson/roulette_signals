import 'package:flutter/material.dart';
import 'package:roulette_signals/data/telegram/telegram_service.dart';
import 'package:roulette_signals/data/websocket/lobby_socket.dart';
import 'package:roulette_signals/data/websocket/table_socket.dart';
import 'package:roulette_signals/domain/logic/signal_engine.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/utils/sound_player.dart';

class MainScreen extends StatefulWidget {
  final AuthResponse authResponse;

  const MainScreen({
    Key? key,
    required this.authResponse,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late LobbySocket _lobbySocket;
  late TableSocket _tableSocket;
  late SignalEngine _signalEngine;
  late TelegramService _telegramService;
  final _soundPlayer = SoundPlayer();
  final List<RouletteNumber> _numbers = [];
  final List<Signal> _signals = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    _telegramService = TelegramService(
      botToken: 'YOUR_BOT_TOKEN', // Замените на реальный токен
      chatId: 'YOUR_CHAT_ID', // Замените на реальный chat_id
    );

    _signalEngine = SignalEngine(
      onSignalDetected: _handleSignal,
    );

    _lobbySocket = LobbySocket(
      sessionId: widget.authResponse.evoSessionId,
      onNumbersReceived: _handleNumbers,
    );

    _tableSocket = TableSocket(
      tableId: 'YOUR_TABLE_ID', // Замените на реальный ID стола
      evoSessionId: widget.authResponse.evoSessionId,
      onNumberReceived: _handleNumber,
    );

    _lobbySocket.connect();
    _tableSocket.connect();
  }

  void _handleNumbers(List<RouletteNumber> numbers) {
    setState(() {
      _numbers.addAll(numbers);
    });
  }

  void _handleNumber(RouletteNumber number) {
    setState(() {
      _numbers.add(number);
    });
    _signalEngine.addNumber(number);
  }

  void _handleSignal(Signal signal) async {
    setState(() {
      _signals.add(signal);
    });

    // Воспроизведение звука
    await _soundPlayer.playPing();

    // Отправка в Telegram
    try {
      await _telegramService.sendSignal(signal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки в Telegram: $e')),
      );
    }

    // Показ уведомления
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(signal.message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _lobbySocket.disconnect();
    _tableSocket.disconnect();
    _soundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Анализатор рулетки')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _numbers.length,
              itemBuilder: (context, index) {
                final number = _numbers[index];
                return ListTile(
                  title: Text('Число: ${number.number}'),
                  subtitle: Text(
                    'Дюжина: ${number.dozen}, Колонка: ${number.column}',
                  ),
                );
              },
            ),
          ),
          if (_signals.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Сигналы:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _signals.length,
                      itemBuilder: (context, index) {
                        final signal = _signals[index];
                        return Card(
                          child: ListTile(
                            title: Text(signal.message),
                            subtitle: Text(
                              'Последние числа: ${signal.lastNumbers.join(', ')}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 