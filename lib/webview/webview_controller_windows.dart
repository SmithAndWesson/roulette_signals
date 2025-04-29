import 'package:webview_windows/webview_windows.dart' as windows;
import 'webview_controller.dart';

/// Реализация WebView для Windows
class WebviewControllerWindows implements AppWebViewController {
  final windows.WebviewController inner = windows.WebviewController();

  @override
  Future<void> initialize() => inner.initialize();

  @override
  Future<void> loadUrl(String url) => inner.loadUrl(url);

  @override
  Future<String> executeScript(String js) async {
    final result = await inner.executeScript(js);
    return result.toString();
  }

  @override
  Stream<LoadingState> get loadingState => inner.loadingState.map((s) =>
      s == windows.LoadingState.navigationCompleted
          ? LoadingState.navigationCompleted
          : LoadingState.navigationStarted);

  @override
  Future<void> dispose() => inner.dispose();
}
