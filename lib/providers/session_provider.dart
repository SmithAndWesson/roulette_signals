import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/models/game_models.dart';

class SessionState {
  final bool isLoggedIn;
  final AuthResponse? authResponse;
  final String? error;

  const SessionState({
    this.isLoggedIn = false,
    this.authResponse,
    this.error,
  });

  SessionState copyWith({
    bool? isLoggedIn,
    AuthResponse? authResponse,
    String? error,
  }) {
    return SessionState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      authResponse: authResponse ?? this.authResponse,
      error: error ?? this.error,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  void handleLoginSuccess({
    required String jwtToken,
    required String evoSessionId,
  }) {
    state = state.copyWith(
      isLoggedIn: true,
      authResponse: AuthResponse(
        jwtToken: jwtToken,
        evoSessionId: evoSessionId,
      ),
      error: null,
    );
  }

  void handleLogout() {
    state = const SessionState();
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});
