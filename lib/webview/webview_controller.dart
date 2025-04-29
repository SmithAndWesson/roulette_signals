/// Абстрактный класс для управления WebView на разных платформах
abstract class AppWebViewController {
  /// Инициализация WebView
  Future<void> initialize();

  /// Загрузка URL в WebView
  Future<void> loadUrl(String url);

  /// Выполнение JavaScript в WebView
  Future<String> executeScript(String js);

  /// Поток состояний загрузки
  Stream<LoadingState> get loadingState;

  /// Освобождение ресурсов
  Future<void> dispose();
}

/// Состояния загрузки страницы
enum LoadingState {
  /// Начало навигации
  navigationStarted,

  /// Завершение навигации
  navigationCompleted,
}
