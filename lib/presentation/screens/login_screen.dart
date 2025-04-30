import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart' as windows;
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/webview/webview_controller.dart';
import 'package:roulette_signals/webview/webview_controller_windows.dart';
import 'package:roulette_signals/webview/webview_factory.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function(AuthResponse) onLoginSuccess;

  const LoginScreen({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AppWebViewController? _controller; // null on Android
  late final WebViewController? _androidCtrl; // null on Windows
  bool _isInitialized = false;
  String? _jwtToken;
  String? _evoSessionId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _androidCtrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _isLoading = true),
            onPageFinished: (_) async {
              setState(() => _isLoading = false);
              _waitForTokens();
            },
          ),
        );
      _androidCtrl!.loadRequest(Uri.parse('https://gizbo.casino'));
    } else {
      _androidCtrl = null;
      _controller = createWebViewController();
      _initWebView();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _initWebView() async {
    if (!mounted) return;

    try {
      await _controller?.initialize();
      await _controller?.loadUrl('https://gizbo.casino');

      if (Platform.isWindows) _pollTokensWindows();

      // Слушаем загрузку страницы
      _controller?.loadingState.listen((state) {
        if (!mounted) return;
        setState(() {
          _isLoading = state == LoadingState.navigationStarted;
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

  Future<void> _pollTokensWindows() async {
    while (mounted && _jwtToken == null) {
      final cookies =
          await _controller!.executeScript('document.cookie') as String?;
      final jwt = await _controller!
          .executeScript('localStorage.getItem("JWT_AUTH")') as String?;

      final evo = _extractEvoSessionId(_cleanResult(cookies ?? ''));
      final jwtToken = _cleanResult(jwt ?? '');

      if (evo != null && jwtToken.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('all_cookies', cookies ?? '');
        setState(() {
          _evoSessionId = evo;
          _jwtToken = jwtToken;
        });
        Logger.info('✅ Токены получены (Windows опрос)');
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Получаем все куки
      final cookieResult = await _controller?.executeScript(
        'document.cookie',
      );

      // Получаем JWT из localStorage
      final jwtResult = await _controller?.executeScript(
        'localStorage.getItem("JWT_AUTH")',
      );

      // Сохраняем все cookies в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('all_cookies', _cleanResult(cookieResult ?? ''));

      // Извлекаем EVOSESSIONID из куков
      final evoSessionId =
          _extractEvoSessionId(_cleanResult(cookieResult ?? ''));
      final jwtToken = _cleanResult(jwtResult ?? '');

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

  Future<void> _waitForTokens() async {
    const timeout = Duration(seconds: 15);
    const interval = Duration(milliseconds: 500);

    final deadline = DateTime.now().add(timeout);

    while (mounted && DateTime.now().isBefore(deadline)) {
      final cookiesRaw =
          await _androidCtrl!.runJavaScriptReturningResult('document.cookie');
      final jwtRaw = await _androidCtrl!
          .runJavaScriptReturningResult('localStorage.getItem("JWT_AUTH")');

      final cookies = _cleanResult(cookiesRaw.toString());
      final jwt = _cleanResult(jwtRaw.toString());

      final evo = _extractEvoSessionId(cookies);
      if (evo != null && jwt.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('all_cookies', cookies);
        setState(() {
          _evoSessionId = evo;
          _jwtToken = jwt;
        });
        Logger.info('Токены получены (Android polling)');
        return;
      }
      await Future.delayed(interval);
    }
    Logger.warning('JWT/EVOSESSIONID не появились за $timeout');
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
    _controller?.dispose(); // safe
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
                child: Platform.isAndroid
                    ? WebViewWidget(controller: _androidCtrl!)
                    : _isInitialized
                        ? windows.Webview(
                            (_controller as WebviewControllerWindows).inner,
                          )
                        : const Center(child: CircularProgressIndicator()),
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
                    ),
                    child: const Text('Продолжить'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
