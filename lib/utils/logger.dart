import 'package:flutter/foundation.dart';

class Logger {
  // Форматируем единый префикс с временем (чтобы легче искать в логе)
  static String _ts() =>
      DateTime.now().toIso8601String().substring(11, 23); // HH:mm:ss.mmm

  static void init() {
    // Инициализация логгера
  }

  static void info(String message) {
    if (kDebugMode) {
      print('[${_ts()}] ℹ️  INFO: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('[${_ts()}] ⚠️  WARNING: $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      print('[${_ts()}] 🐛 DEBUG: $message');
    }
  }

  /// Лог ошибки c опциональными `error` и `stackTrace`.
  static void error(String message, [dynamic error]) {
    if (!kDebugMode) return;

    final buf = StringBuffer('[${_ts()}] ❌ ERROR: $message');
    if (error != null) {
      buf.write('\n   ↳ $error');
    }
    print(buf.toString());
  }
}
