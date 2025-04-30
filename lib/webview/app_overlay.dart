import 'package:flutter/widgets.dart';

/// Глобальный navigatorKey для доступа к Overlay из сервисов.
class AppOverlay {
  static final navigatorKey = GlobalKey<NavigatorState>();
}
