import 'package:flutter/material.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function(AuthResponse) onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = WebviewController();
  bool _isInitialized = false;
  String? _jwtToken;
  String? _evoSessionId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _initWebView() async {
    if (!mounted) return;

    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.white);
      await _controller.loadUrl('https://gizbo.casino');

      // Слушаем изменения URL
      _controller.url.listen((url) {
        Logger.debug('URL изменен: $url');
        _checkAuthStatus();
      });

      // Слушаем загрузку страницы
      _controller.loadingState.listen((state) {
        if (!mounted) return;
        setState(() {
          _isLoading = state == LoadingState.loading;
        });
        if (state == LoadingState.navigationCompleted) {
          Logger.info('Страница загружена');
          _checkAuthStatus();
        }
      });

      if (!mounted) return;
      setState(() => _isInitialized = true);
      Logger.info('WebView инициализирован');
    } catch (e) {
      Logger.error('Ошибка инициализации WebView', e);
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Получаем все куки
      final cookieResult = await _controller.executeScript(
        'document.cookie',
      );

      // Получаем JWT из localStorage
      final jwtResult = await _controller.executeScript(
        'localStorage.getItem("JWT_AUTH")',
      );

      // Сохраняем все cookies в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('all_cookies', _cleanResult(cookieResult));

      // Извлекаем EVOSESSIONID из куков
      final evoSessionId = _extractEvoSessionId(_cleanResult(cookieResult));
      final jwtToken = _cleanResult(jwtResult);

      if (evoSessionId != null && jwtToken.isNotEmpty) {
        setState(() {
          _evoSessionId = evoSessionId;
          _jwtToken = jwtToken;
        });
        Logger.info('Токены получены успешно');
      } else {
        Logger.warning('Токены не найдены');
      }
    } catch (e) {
      Logger.error('Ошибка проверки авторизации', e);
    }
  }

  String? _extractEvoSessionId(String cookies) {
    final pattern = RegExp(r'original_user_id=([^;]+)');
    final match = pattern.firstMatch(cookies);
    return match?.group(1);
  }

  String _cleanResult(String result) {
    return result.replaceAll('"', '').trim();
  }

  void _onContinue() {
    if (_jwtToken != null && _evoSessionId != null) {
      Logger.info('Переход к основному экрану');
      widget.onLoginSuccess(
        AuthResponse(
          jwtToken: _jwtToken!,
          evoSessionId: _evoSessionId!,
        ),
      );
    } else {
      Logger.warning('Попытка продолжить без токенов');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Токены не получены. Пожалуйста, войдите в систему.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    Logger.info('Очистка ресурсов WebView');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Roulette Signals',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Webview(_controller),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              if (_jwtToken != null && _evoSessionId != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
