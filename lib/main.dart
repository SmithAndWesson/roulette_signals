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
      title: 'Roulette Signals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  void _handleLoginSuccess(AuthResponse response) {
    Logger.info('Успешный вход: ${response.jwtToken}');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainScreen(authResponse: response)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      onLoginSuccess: _handleLoginSuccess,
    );
  }
}
