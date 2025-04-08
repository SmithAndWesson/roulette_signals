import 'package:flutter/material.dart';
import 'package:roulette_signals/models/game_models.dart';
import 'package:roulette_signals/presentation/screens/login_screen.dart';
import 'package:roulette_signals/presentation/screens/main_screen.dart';
import 'package:roulette_signals/utils/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Анализатор рулетки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(
        onLoginSuccess: _handleLoginSuccess,
      ),
    );
  }
}

void _handleLoginSuccess(AuthResponse response) {
  // В реальном приложении здесь нужно использовать Navigator
  // для перехода на главный экран
  Logger.info('Успешный вход: ${response.jwtToken}');
}
