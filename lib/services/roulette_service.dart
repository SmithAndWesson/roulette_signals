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

      // Устанавливаем cookies
      await controller.executeScript('''
        document.cookie = "$savedCookies";
      ''');

      final completer = Completer<String>();

      // Слушаем загрузку страницы
      controller.loadingState.listen((state) async {
        if (state == LoadingState.navigationCompleted) {
          try {
            final iframeSrc = await controller.executeScript('''
              document.querySelector('iframe') ? document.querySelector('iframe').src : ''
            ''');

            if (iframeSrc != null && iframeSrc.isNotEmpty) {
              completer.complete(iframeSrc);
            } else {
              completer.completeError('iframe не найден');
            }
          } catch (e) {
            completer.completeError(e);
          }
        }
      });

      // Загружаем страницу
      final fullUrl = 'https://gizbo.casino$playUrl';
      Logger.info('WebSocket URL: $fullUrl');
      await controller.loadUrl(fullUrl);

      // Ждем получения src iframe
      final iframeSrc = await completer.future;

      // Извлекаем параметр options из iframeSrc
      final iframeUri = Uri.parse(iframeSrc);
      final optionsEncoded = iframeUri.queryParameters['options'];
      if (optionsEncoded == null) {
        throw Exception('Параметр options не найден в iframe');
      }

      // Декодируем options
      final optionsNormalized = _normalizeBase64(optionsEncoded as String);
      final optionsDecoded = utf8.decode(base64.decode(optionsNormalized));

      // Парсим JSON
      final Map<String, dynamic> optionsMap = jsonDecode(optionsDecoded);
      final launchOpts = optionsMap['launch_options'] as Map<String, dynamic>?;
      if (launchOpts == null || launchOpts['game_url'] == null) {
        throw Exception('game_url не найден в launch_options');
      }
      final gameUrl = launchOpts['game_url'] as String;

      // Извлекаем параметр params
      final gameUri = Uri.parse(gameUrl);
      final paramsEncoded = gameUri.queryParameters['params'];
      if (paramsEncoded == null) {
        throw Exception('Параметр params не найден в game_url');
      }

      final jsessionId = gameUri.queryParameters['JSESSIONID'];
      if (jsessionId == null) {
        throw Exception('JSESSIONID не найден в game_url');
      }
      // Декодируем params
      final paramsNormalized = _normalizeBase64(paramsEncoded as String);
      final paramsDecoded = utf8.decode(base64.decode(paramsNormalized));
      final params = _parseKeyValueString(paramsDecoded);

      final tableId = params['table_id'];
      final vtId = params['vt_id'];
      final uaLaunchId = params['ua_launch_id'];
      final clientVersion =
          '6.20250415.70424.51183-8793aee83a'; //params['client_version'];

      if (tableId == null || vtId == null || clientVersion == null) {
        throw Exception('Некорректные параметры подключения');
      }

      // Формируем instance
      final random = Random().nextInt(1000000);
      final instance = '$random-$evoSessionId-$vtId';

      return WebSocketParams(
        tableId: tableId,
        vtId: vtId,
        uaLaunchId: uaLaunchId ?? '',
        clientVersion: clientVersion,
        evoSessionId: jsessionId,
        instance: instance,
      );
    } catch (e) {
      Logger.error('Ошибка извлечения параметров WebSocket', e);
      rethrow;
    }
  }
}
