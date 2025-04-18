import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_windows/webview_windows.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class RouletteService {
  static const String _baseUrl = 'https://gizbo.casino/batch?cms[]=';
  static const String _gamesEndpoint = 'api/cms/v2/games/UAH';
  static const String _restrictionsEndpoint =
      'https://gizbo.casino/batch?base[]=api/v2/player&base[]=api/player/stats&base[]=api/v2/player/settings&base[]=api/v3/auth_provider_settings?country=UA&base[]=api/v3/exchange_rates&base[]=api/v3/fixed_exchange_rates&base[]=api/v4/player/limits&base[]=api/v2/games/restrictions?country=UA';

  Future<List<RouletteGame>> fetchLiveRouletteGames() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_gamesEndpoint'));

      if (response.statusCode != 200) {
        throw Exception('Ошибка получения списка игр: ${response.statusCode}');
      }

      final Map<String, dynamic> root = json.decode(response.body);
      final Map<String, dynamic> data = root['CmsApiCmsV2GamesUAH']['data'];

      final List<RouletteGame> rouletteGames = data.values
          .map((game) => RouletteGame.fromJson(game))
          .where((game) =>
              game.collections.contains('online_live_casino') &&
              game.collections.contains('live_roulette') &&
              game.slug.contains('online-live-casino'))
          .toList();

      final restrictions = await _fetchGameRestrictions();
      final restrictedProviders =
          List<String>.from(restrictions['producers'] ?? []);
      final restrictedGames = List<String>.from(restrictions['games'] ?? []);

      final filteredGames = rouletteGames.where((game) {
        // формируем ключ в формате provider:gameName
        final gameKey = game.identifier.replaceFirst('/', ':');
        final isRestricted = restrictedGames.contains(gameKey) ||
            restrictedProviders.contains(game.provider);

        if (isRestricted) {
          Logger.debug('Игра заблокирована: ${game.title} (${game.provider})');
        }

        return !isRestricted;
      }).toList();

      Logger.info('Получено ${filteredGames.length} рулеток');
      return filteredGames;
    } catch (e) {
      Logger.error('Ошибка при получении списка рулеток', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchGameRestrictions() async {
    final response = await http.get(Uri.parse(_restrictionsEndpoint));
    if (response.statusCode != 200) {
      throw Exception('Ошибка получения ограничений: ${response.statusCode}');
    }
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return jsonData['BaseApiV2GamesRestrictions']?['restrictions'] ?? {};
  }

  String _normalizeBase64(String input) {
    var cleaned = input.replaceAll(RegExp(r'[^A-Za-z0-9+/]'), '');
    final mod = cleaned.length % 4;
    if (mod != 0) cleaned += '=' * (4 - mod);
    return cleaned;
  }

  Map<String, String> _parseKeyValueString(String input) {
    final Map<String, String> result = {};
    for (var line in input.split('\n')) {
      if (!line.contains('=')) continue;
      final idx = line.indexOf('=');
      final key = line.substring(0, idx).trim();
      final value = line.substring(idx + 1).trim();
      result[key] = value;
    }
    return result;
  }

  Future<WebSocketParams> extractWebSocketParams(
      String playUrl, String evoSessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCookies = prefs.getString('all_cookies') ?? '';

      final controller = WebviewController();
      await controller.initialize();

      // Устанавливаем сохранённые cookies для gizbo.casino
      await controller.executeScript('''
      document.cookie = "$savedCookies";
    ''');

      // Два Completer'а: первый для iframeSrc, второй — для cookieHeader
      final iframeCompleter = Completer<String>();
      final cookieCompleter = Completer<String>();

      // Стартовая стадия: ждем iframe
      int stage = 0;
      late String gameUrl;

      // Одна подписка на loadingState
      controller.loadingState.listen((state) async {
        if (state != LoadingState.navigationCompleted) return;

        try {
          if (stage == 0) {
            // 1) получили iframe src
            final src = await controller.executeScript('''
            document.querySelector('iframe')?.src ?? ''
          ''');
            if (src is String && src.isNotEmpty) {
              iframeCompleter.complete(src);
              stage = 1; // переход к следующей стадии
            } else {
              iframeCompleter.completeError('iframe не найден');
            }
          } else {
            // 2) после загрузки gameUrl — достаём куки
            final rawJs = await controller.executeScript('document.cookie');
            final cookieHeader =
                (rawJs as String).replaceAll(r'\"', '"').replaceAll('"', '');
            cookieCompleter.complete(cookieHeader);
            // Больше не нужен слушатель
          }
        } catch (e) {
          if (stage == 0)
            iframeCompleter.completeError(e);
          else
            cookieCompleter.completeError(e);
        }
      });

      // 1) Загружаем первую страницу, чтобы вытянуть iframe
      final fullUrl = 'https://gizbo.casino$playUrl';
      Logger.info('Load gizbo page: $fullUrl');
      await controller.loadUrl(fullUrl);
      final iframeSrc = await iframeCompleter.future;

      // 2) Парсим iframeSrc → options → gameUrl
      final iframeUri = Uri.parse(iframeSrc);
      final optionsEncoded = iframeUri.queryParameters['options'];
      if (optionsEncoded == null) {
        throw Exception('Параметр options не найден в iframe');
      }
      final optionsNorm = _normalizeBase64(optionsEncoded);
      final optionsJson = utf8.decode(base64.decode(optionsNorm));
      final optionsMap = jsonDecode(optionsJson) as Map<String, dynamic>;
      final launchOpts = optionsMap['launch_options'] as Map<String, dynamic>?;
      if (launchOpts == null || launchOpts['game_url'] == null) {
        throw Exception('game_url не найден в launch_options');
      }
      gameUrl = launchOpts['game_url'] as String;

      // 3) Загружаем страницу gameUrl, чтобы WebView выставил реальные куки
      Logger.info('Load game page: $gameUrl');
      await controller.loadUrl(gameUrl);

      // и ждём извлечения куки
      final cookieHeader = await cookieCompleter.future;
      Logger.debug('Real royal cookies: $cookieHeader');

      // 4) Парсим params из gameUrl
      final gameUri = Uri.parse(gameUrl);
      final paramsEncoded = gameUri.queryParameters['params'];
      final jsessionId = gameUri.queryParameters['JSESSIONID'];
      if (paramsEncoded == null) {
        throw Exception('Параметр params не найден в game_url');
      }
      if (jsessionId == null) {
        throw Exception('JSESSIONID не найден в game_url');
      }
      final paramsNorm = _normalizeBase64(paramsEncoded);
      final paramsJson = utf8.decode(base64.decode(paramsNorm));
      final paramsMap = _parseKeyValueString(paramsJson);

      final tableId = paramsMap['table_id']!;
      final vtId = paramsMap['vt_id']!;
      final uaLaunchId = paramsMap['ua_launch_id'] ?? '';
      final clientVersion = '6.20250415.70424.51183-8793aee83a';

      // 5) Формируем instance
      final instance = '${Random().nextInt(1 << 20)}-$evoSessionId-$vtId';

      return WebSocketParams(
        tableId: tableId,
        vtId: vtId,
        uaLaunchId: uaLaunchId,
        clientVersion: clientVersion,
        evoSessionId: jsessionId,
        instance: instance,
        cookieHeader: cookieHeader,
      );
    } catch (e) {
      Logger.error('Ошибка извлечения параметров WebSocket', e);
      rethrow;
    }
  }
}
