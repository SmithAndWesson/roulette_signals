import 'dart:io' show Platform;
import 'webview_controller.dart';
import 'webview_controller_windows.dart';
import 'webview_controller_android.dart';

/// Фабрика для создания WebView-контроллера
AppWebViewController createWebViewController() {
  if (Platform.isWindows) return WebviewControllerWindows();
  if (Platform.isAndroid) return WebviewControllerAndroid();
  throw UnsupportedError('WebView не реализован для этой платформы');
}
