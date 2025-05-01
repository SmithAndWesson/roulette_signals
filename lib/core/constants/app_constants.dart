class AppConstants {
  static const String loginUrl = 'https://gizbo.casino/login';
  static const String baseUrl = 'https://gizbo.casino';
  static const String wsBaseUrl = 'wss://royal.evo-games.com';

  // Ключи для хранения данных
  static const String jwtTokenKey = 'jwt_token';
  static const String evoSessionIdKey = 'evo_session_id';
  static const String cookiesKey = 'all_cookies';

  // Таймауты
  static const int loginTimeoutSeconds = 30;
  static const int wsTimeoutSeconds = 10;
  static const int analysisIntervalSeconds = 1;

  // Версии
  static const String clientVersion = '6.20250415.70424.51183-8793aee83a';
}
