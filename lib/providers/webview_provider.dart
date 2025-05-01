import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roulette_signals/services/webview/webview_service.dart';

final webViewServiceProvider = Provider<WebViewService>((ref) {
  return WebViewService();
});
