import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:roulette_signals/services/session/session_manager.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:flutter/widgets.dart';
import '../../core/constants/app_constants.dart';
import 'package:roulette_signals/models/game_models.dart';

class WebViewService {
  static final WebViewService _instance = WebViewService._();
  WebViewController? _controller;
  bool _initialized = false;

  WebViewService._();

  factory WebViewService() => _instance;

  Future<void> init() async {
    if (_initialized) return;

    try {
      Logger.info('Инициализация WebView');

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) async {
              // После загрузки пытаемся забрать куки и JWT
              await _extractSession();
            },
            onWebResourceError: (error) {
              Logger.error('Ошибка WebView: ${error.description}');
            },
          ),
        );

      _initialized = true;
      Logger.info('WebView инициализирован');
    } catch (e) {
      Logger.error('Ошибка инициализации WebView', e);
      rethrow;
    }
  }

  Future<void> loadLoginPage() async {
    await init();
    if (_controller == null) {
      throw Exception('WebView не инициализирован');
    }
    await _controller!.loadRequest(Uri.parse(AppConstants.loginUrl));
  }

  Future<void> _extractSession() async {
    if (_controller == null) {
      Logger.error('WebView не инициализирован');
      return;
    }

    try {
      final cookieStr = await _controller!.runJavaScriptReturningResult(
        'document.cookie',
      ) as String;

      final jwtToken = _extractToken(cookieStr, 'jwt_token');
      final evoSessionId = _extractToken(cookieStr, 'evo_session_id');

      if (jwtToken != null && evoSessionId != null) {
        await SessionManager().saveSession(
          jwtToken: jwtToken,
          evoSessionId: evoSessionId,
        );
        Logger.info('Сессия извлечена из WebView');
      } else {
        Logger.warning('Токены не найдены в куках');
      }
    } catch (e) {
      Logger.error('Ошибка извлечения сессии из WebView', e);
    }
  }

  String? _extractToken(String cookies, String tokenName) {
    final regex = RegExp('$tokenName=([^;]+)');
    final match = regex.firstMatch(cookies);
    return match?.group(1);
  }

  WebViewController get controller {
    if (!_initialized || _controller == null) {
      throw Exception('WebViewService не инициализирован');
    }
    return _controller!;
  }

  Widget buildWebView() {
    return WebViewWidget(controller: controller);
  }

  Future<void> dispose() async {
    _initialized = false;
    _controller = null;
    Logger.info('WebView остановлен');
  }

  Future<AuthResponse> login() async {
    if (_controller == null) {
      await init();
    }

    _controller!
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _checkAuthStatus();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gizbo.casino'));

    // Ждем пока пользователь авторизуется
    final cookies = await _waitForAuth();
    final jwtToken = _extractToken(cookies, 'jwt_token');
    final evoSessionId = _extractToken(cookies, 'evo_session_id');

    if (jwtToken == null || evoSessionId == null) {
      throw Exception('Не удалось получить токены авторизации');
    }

    return AuthResponse(
      jwtToken: jwtToken,
      evoSessionId: evoSessionId,
    );
  }

  Future<void> _checkAuthStatus() async {
    if (_controller == null) return;

    final cookies = await _controller!.runJavaScriptReturningResult(
      'document.cookie',
    ) as String;

    final jwtToken = _extractToken(cookies, 'jwt_token');
    final evoSessionId = _extractToken(cookies, 'evo_session_id');

    if (jwtToken != null && evoSessionId != null) {
      Logger.info('Авторизация успешна');
    }
  }

  Future<String> _waitForAuth() async {
    int attempts = 0;
    const maxAttempts = 60; // 1 минута
    const delay = Duration(seconds: 1);

    while (attempts < maxAttempts) {
      final cookies = await _controller!.runJavaScriptReturningResult(
        'document.cookie',
      ) as String;

      final jwtToken = _extractToken(cookies, 'jwt_token');
      final evoSessionId = _extractToken(cookies, 'evo_session_id');

      if (jwtToken != null && evoSessionId != null) {
        return cookies;
      }

      await Future.delayed(delay);
      attempts++;
    }

    throw Exception('Таймаут авторизации');
  }
}
