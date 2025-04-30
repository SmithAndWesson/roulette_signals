import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webview_controller.dart';
import 'app_overlay.dart';

/// «Headless» WebView на базе webview_flutter.
/// Работает через невидимый OverlayEntry.
class WebviewControllerAndroid implements AppWebViewController {
  late final WebViewController _ctrl;
  final _loading = StreamController<LoadingState>();
  OverlayEntry? _entry;

  @override
  Future<void> initialize() async {
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _loading.add(LoadingState.navigationStarted),
          onPageFinished: (_) => _loading.add(LoadingState.navigationCompleted),
        ),
      );

    // Вставляем невидимый WebView в Overlay верхнего Navigator
    _entry = OverlayEntry(
      builder: (_) => Offstage(
        offstage: true,
        child: SizedBox(
          width: 0,
          height: 0,
          child: WebViewWidget(controller: _ctrl),
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppOverlay.navigatorKey.currentState!.overlay!.insert(_entry!);
    });
  }

  @override
  Future<void> loadUrl(String url) => _ctrl.loadRequest(Uri.parse(url));

  @override
  Future<String> executeScript(String js) async =>
      (await _ctrl.runJavaScriptReturningResult(js)).toString();

  @override
  Stream<LoadingState> get loadingState => _loading.stream;

  @override
  Future<void> dispose() async {
    await _ctrl.runJavaScript(''); // гарантируем остановку
    _entry?.remove();
    await _loading.close();
  }
}
