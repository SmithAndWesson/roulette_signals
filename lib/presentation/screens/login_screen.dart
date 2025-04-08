import 'package:flutter/material.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:webview_windows/webview_windows.dart';

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

  Future<void> _initWebView() async {
    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.white);
      await _controller.loadUrl('https://gizbo.casino');

      // Слушаем изменения URL
      _controller.url.listen((url) {
        _checkAuthStatus();
      });

      // Слушаем загрузку страницы
      _controller.loadingState.listen((state) {
        setState(() {
          _isLoading = state == LoadingState.loading;
        });
        if (state == LoadingState.navigationCompleted) {
          _checkAuthStatus();
        }
      });

      setState(() => _isInitialized = true);
    } catch (e) {
      print('Ошибка инициализации WebView: $e');
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Получаем JWT из localStorage
      final jwtResult = await _controller.executeScript(
        'localStorage.getItem("JWT_AUTH")',
      );

      // Получаем все куки
      final cookieResult = await _controller.executeScript(
        'document.cookie',
      );

      // Извлекаем EVOSESSIONID из куков
      final evoSessionId = _extractEvoSessionId(_cleanResult(cookieResult));
      final jwtToken = _cleanResult(jwtResult);

      if (evoSessionId != null && jwtToken.isNotEmpty) {
        setState(() {
          _evoSessionId = evoSessionId;
          _jwtToken = jwtToken;
        });
      }
    } catch (e) {
      print('Ошибка проверки авторизации: $e');
    }
  }

  String? _extractEvoSessionId(String cookies) {
    final pattern = RegExp(r'EVOSESSIONID=([^;]+)');
    final match = pattern.firstMatch(cookies);
    return match?.group(1);
  }

  String _cleanResult(String result) {
    return result.replaceAll('"', '').trim();
  }

  void _onContinue() {
    if (_jwtToken != null && _evoSessionId != null) {
      widget.onLoginSuccess(
        AuthResponse(
          jwtToken: _jwtToken!,
          evoSessionId: _evoSessionId!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Токены не получены. Пожалуйста, войдите в систему.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход через WebView (Windows)'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: _isInitialized
          ? Stack(
              children: [
                Webview(_controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onContinue,
        label: const Text('Продолжить'),
        icon: const Icon(Icons.login),
      ),
    );
  }
}
