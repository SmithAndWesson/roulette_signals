import 'package:flutter/widgets.dart';
import '../presentation/expired_app.dart';

final _expiryRaw = const String.fromEnvironment('EXPIRY', defaultValue: '');
final DateTime? _expiry =
    _expiryRaw.isEmpty ? null : DateTime.parse(_expiryRaw);

class ExpiryWatcher with WidgetsBindingObserver {
  static final ExpiryWatcher _i = ExpiryWatcher._();
  static ExpiryWatcher get i => _i;
  ExpiryWatcher._();

  void start() {
    if (_expiry == null) return; // флага нет – ничего не делаем
    WidgetsBinding.instance.addObserver(this);
    _check(); // проверка сразу после запуска
  }

  void dispose() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  void _check() {
    if (_expiry != null && DateTime.now().isAfter(_expiry!)) {
      runApp(const ExpiredApp());
    }
  }
}
