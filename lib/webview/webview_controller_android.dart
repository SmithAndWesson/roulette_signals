import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webview_controller.dart';

/// Реализация WebView для Android
class WebviewControllerAndroid implements AppWebViewController {
  late HeadlessInAppWebView _headless;
  late InAppWebViewController _controller;
  final _loading = StreamController<LoadingState>();

  @override
  Future<void> initialize() async {
    _headless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri('about:blank')),
      onWebViewCreated: (c) => _controller = c,
      onLoadStart: (_, __) => _loading.add(LoadingState.navigationStarted),
      onLoadStop: (_, __) async {
        _loading.add(LoadingState.navigationCompleted);
        // Сохраняем cookies после загрузки страницы
        final currentUrl = await _controller.getUrl();
        if (currentUrl != null) {
          final cookies = await CookieManager.instance().getCookies(
            url: currentUrl,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'all_cookies',
            cookies.map((c) => '${c.name}=${c.value}').join('; '),
          );
        }
      },
    );
    await _headless.run();
  }

  @override
  Future<void> loadUrl(String url) =>
      _controller.loadUrl(urlRequest: URLRequest(url: WebUri(url)));

  @override
  Future<String> executeScript(String js) async =>
      (await _controller.evaluateJavascript(source: js)).toString();

  @override
  Stream<LoadingState> get loadingState => _loading.stream;

  @override
  Future<void> dispose() async {
    await _headless.dispose();
    await _loading.close();
  }
}
