import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/services/session/session_manager.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoggedIn;
  final String? jwtToken;
  final String? evoSessionId;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isLoggedIn = false,
    this.jwtToken,
    this.evoSessionId,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? jwtToken,
    String? evoSessionId,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      jwtToken: jwtToken ?? this.jwtToken,
      evoSessionId: evoSessionId ?? this.evoSessionId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _sessionManager = SessionManager();

  AuthNotifier() : super(AuthState()) {
    checkSession();
  }

  Future<void> checkSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final isLoggedIn = await _sessionManager.hasValidSession();
      if (isLoggedIn) {
        final jwtToken = await _sessionManager.getJwtToken();
        final evoSessionId = await _sessionManager.getEvoSessionId();
        state = state.copyWith(
          isLoggedIn: true,
          jwtToken: jwtToken,
          evoSessionId: evoSessionId,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> handleLoginSuccess({
    required String jwtToken,
    required String evoSessionId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _sessionManager.saveSession(
        jwtToken: jwtToken,
        evoSessionId: evoSessionId,
      );
      state = state.copyWith(
        isLoggedIn: true,
        jwtToken: jwtToken,
        evoSessionId: evoSessionId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _sessionManager.clearSession();
      state = state.copyWith(
        isLoggedIn: false,
        jwtToken: null,
        evoSessionId: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
