import 'dart:async';
import 'dart:io' show Platform; // ← добавили
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // ← добавили
import 'package:shared_preferences/shared_preferences.dart';
import 'webview_controller.dart';
import 'app_overlay.dart';

/// «Headless» WebView на базе webview_flutter.
/// Работает через невидимый OverlayEntry.
class WebviewControllerAndroid implements AppWebViewController {
  late final WebViewController _ctrl;
  late final WebViewCookieManager _cookieMgr;
  final _loading = StreamController<LoadingState>();
  OverlayEntry? _entry;

  @override
  Future<void> initialize() async {
    _cookieMgr = WebViewCookieManager();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _loading.add(LoadingState.navigationStarted),
          onPageFinished: (_) => _loading.add(LoadingState.navigationCompleted),
        ),
      );

// 1. Собираем "базовые" параметры из platform-сборки
    final baseParams = PlatformWebViewWidgetCreationParams(
      controller: _ctrl.platform, // берём внутренний контроллер
      layoutDirection: TextDirection.ltr, // или ваш вариант
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    );

// 2. Если мы на Android — создаём Android-специфичный params с hybrid-composition
    final effectiveParams = (WebViewPlatform.instance is AndroidWebViewPlatform)
        ? AndroidWebViewWidgetCreationParams(
            controller: baseParams.controller,
            layoutDirection: baseParams.layoutDirection,
            gestureRecognizers: baseParams.gestureRecognizers,
            displayWithHybridComposition: true, // <— включаем hybrid
          )
        : baseParams;

    // Вставляем невидимый WebView в Overlay верхнего Navigator
    _entry = OverlayEntry(
      builder: (_) => Offstage(
        offstage: true,
        child: SizedBox(
          width: 0,
          height: 0,
          child: WebViewWidget.fromPlatformCreationParams(
            params: effectiveParams,
          ),
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
