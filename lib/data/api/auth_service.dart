import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/utils/logger.dart';

class AuthService {
  static const String _baseUrl = 'https://gizbo.casino';
  static const String _loginEndpoint = '/api/users/sign_in';

  Future<AuthResponse> login(UserCredentials credentials) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_loginEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: jsonEncode(credentials.toJson()),
    );

    Logger.debug('Статус: ${response.statusCode}');
    Logger.debug('Тело ответа: ${response.body}');
    Logger.debug('Заголовки: ${response.headers}');

    if (response.statusCode != 200) {
      throw Exception('Ошибка авторизации: ${response.statusCode}');
    }

    // Вариант: попробовать получить JWT из тела или headers (если вдруг сервер всё же отдаёт)
    final jwtToken = 'TODO: parse from response.body or headers';
    final evoSessionId = 'TODO: parse from response.headers["set-cookie"]';

    return AuthResponse(
      jwtToken: jwtToken,
      evoSessionId: evoSessionId,
    );
  }
}
