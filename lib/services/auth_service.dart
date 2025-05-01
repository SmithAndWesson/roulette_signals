import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/providers/webview_provider.dart';
import 'package:roulette_signals/utils/logger.dart';

class AuthService {
  final ProviderContainer _container = ProviderContainer();

  Future<AuthResponse> login() async {
    try {
      final webViewService = _container.read(webViewServiceProvider);
      final result = await webViewService.login();
      return AuthResponse(
        jwtToken: result.jwtToken,
        evoSessionId: result.evoSessionId,
      );
    } catch (e) {
      Logger.error('Ошибка авторизации в AuthService', e);
      rethrow;
    }
  }
}
