import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/core/di/service_locator.dart';
import 'package:roulette_signals/presentation/screens/login_screen.dart';
import 'package:roulette_signals/presentation/screens/main_screen.dart';
import 'package:roulette_signals/providers/session_provider.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:roulette_signals/models/game_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider);

    return MaterialApp(
      title: 'Roulette Signals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: sessionState.isLoggedIn
          ? MainScreen(authResponse: sessionState.authResponse!)
          : LoginScreen(
              onLoginSuccess: (authResponse) {
                ref.read(sessionProvider.notifier).handleLoginSuccess(
                      jwtToken: authResponse.jwtToken,
                      evoSessionId: authResponse.evoSessionId,
                    );
              },
            ),
    );
  }
}
