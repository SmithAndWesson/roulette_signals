import 'package:flutter/foundation.dart';
import 'package:roulette_signals/services/session/session_manager.dart';

class SessionProvider extends ChangeNotifier {
  final _sessionManager = SessionManager();
  bool _isLoggedIn = false;
  String? _jwtToken;
  String? _evoSessionId;

  bool get isLoggedIn => _isLoggedIn;
  String? get jwtToken => _jwtToken;
  String? get evoSessionId => _evoSessionId;

  Future<void> checkSession() async {
    _isLoggedIn = await _sessionManager.hasValidSession();
    if (_isLoggedIn) {
      _jwtToken = await _sessionManager.getJwtToken();
      _evoSessionId = await _sessionManager.getEvoSessionId();
    }
    notifyListeners();
  }

  Future<void> handleLoginSuccess({
    required String jwtToken,
    String? evoSessionId,
  }) async {
    await _sessionManager.saveSession(
      jwtToken: jwtToken,
      evoSessionId: evoSessionId,
    );

    _jwtToken = jwtToken;
    _evoSessionId = evoSessionId;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _sessionManager.clearSession();
    _isLoggedIn = false;
    _jwtToken = null;
    _evoSessionId = null;
    notifyListeners();
  }
}
