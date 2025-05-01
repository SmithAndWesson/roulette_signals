import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'webview_service.dart';

final webViewServiceProvider = Provider<WebViewService>((ref) {
  final service = WebViewService();
  ref.onDispose(() => service.dispose());
  return service;
});
