import 'package:flutter/foundation.dart';

class Logger {
  static void info(String message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }

  static void error(String message, [Object? error]) {
    if (kDebugMode) {
      print('❌ ERROR: $message${error != null ? '\n$error' : ''}');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('⚠️ WARNING: $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      print('🐛 DEBUG: $message');
    }
  }
}
