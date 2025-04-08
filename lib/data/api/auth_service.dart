import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/game_models.dart';

class AuthService {
  static const String _baseUrl = 'https://gizbo.casino';
  static const String _loginEndpoint = '/api/users/sign_in';

  Future<AuthResponse> login(UserCredentials credentials) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_loginEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка авторизации: ${response.statusCode}');
    }

    // В реальном приложении здесь нужно извлечь JWT и EVOSESSIONID
    // из ответа сервера и куков
    return AuthResponse(
      jwtToken: 'dummy_jwt_token', // Замените на реальное извлечение
      evoSessionId: 'dummy_evo_session', // Замените на реальное извлечение
    );
  }
} 