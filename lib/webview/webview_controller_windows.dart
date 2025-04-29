import 'package:webview_windows/webview_windows.dart' as windows;
import 'webview_controller.dart';

/// Реализация WebView для Windows
class WebviewControllerWindows implements AppWebViewController {
  final _inner = windows.WebviewController();

  @override
  Future<void> initialize() => _inner.initialize();

  @override
  Future<void> loadUrl(String url) => _inner.loadUrl(url);

  @override
  Future<String> executeScript(String js) async {
    final result = await _inner.executeScript(js);
    return result.toString();
  }

  @override
  Stream<LoadingState> get loadingState => _inner.loadingState.map((s) =>
      s == windows.LoadingState.navigationCompleted
          ? LoadingState.navigationCompleted
          : LoadingState.navigationStarted);

  @override
  Future<void> dispose() => _inner.dispose();
}
