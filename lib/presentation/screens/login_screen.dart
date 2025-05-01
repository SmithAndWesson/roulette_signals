import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/providers/webview_provider.dart';
import 'package:roulette_signals/services/auth_service.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(AuthResponse) onLoginSuccess;

  const LoginScreen({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    try {
      final webViewService = ref.read(webViewServiceProvider);
      await webViewService.init();
      await webViewService.loadLoginPage();
    } catch (e) {
      Logger.error('Ошибка инициализации WebView', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка инициализации WebView'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final webViewService = ref.watch(webViewServiceProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Roulette Signals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 400,
                child: WebViewWidget(
                  controller: webViewService.controller,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final authService = AuthService();
                    final authResponse = await authService.login();
                    widget.onLoginSuccess(authResponse);
                  } catch (e) {
                    Logger.error('Ошибка авторизации', e);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ошибка авторизации'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ref.read(webViewServiceProvider).dispose();
    super.dispose();
  }
}
