import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/game_models.dart';

class TelegramService {
  final String botToken;
  final String chatId;

  TelegramService({
    required this.botToken,
    required this.chatId,
  });

  Future<void> sendSignal(Signal signal) async {
    final url = Uri.parse(
      'https://api.telegram.org/bot$botToken/sendMessage',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chat_id': chatId,
        'text': signal.message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка отправки сообщения в Telegram: ${response.statusCode}');
    }
  }
} 