import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roulette_signals/utils/logger.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;

  SessionManager._internal();

  final _storage = SharedPreferences.getInstance();
  final _secureStorage = FlutterSecureStorage();

  String? _jwtToken;
  String? _evoSessionId;

  Future<void> saveSession({
    required String jwtToken,
    String? evoSessionId,
  }) async {
    try {
      await _secureStorage.write(key: 'jwt_token', value: jwtToken);
      if (evoSessionId != null) {
        await _secureStorage.write(key: 'evo_session_id', value: evoSessionId);
      }

      _jwtToken = jwtToken;
      _evoSessionId = evoSessionId;

      Logger.info('Сессия сохранена');
    } catch (e) {
      Logger.error('Ошибка сохранения сессии', e);
      rethrow;
    }
  }

  Future<bool> hasValidSession() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null) return false;

      // TODO: Добавить проверку валидности JWT
      return true;
    } catch (e) {
      Logger.error('Ошибка проверки сессии', e);
      return false;
    }
  }

  Future<void> clearSession() async {
    try {
      final prefs = await _storage;
      await prefs.clear();
      await _secureStorage.deleteAll();

      _jwtToken = null;
      _evoSessionId = null;

      Logger.info('Сессия очищена');
    } catch (e) {
      Logger.error('Ошибка очистки сессии', e);
      rethrow;
    }
  }

  Future<String?> getJwtToken() async {
    if (_jwtToken != null) return _jwtToken;
    return await _secureStorage.read(key: 'jwt_token');
  }

  Future<String?> getEvoSessionId() async {
    if (_evoSessionId != null) return _evoSessionId;
    return await _secureStorage.read(key: 'evo_session_id');
  }

  Future<String?> getCookies() async {
    final prefs = await _storage;
    return prefs.getString('all_cookies');
  }
}
