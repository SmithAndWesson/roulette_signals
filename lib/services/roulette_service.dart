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

      Logger.debug('Заблокированные провайдеры: $restrictedProviders');
      Logger.debug('Заблокированные игры: $restrictedGames');

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
      final optionsJsonStr = utf8.decode(base64.decode(optionsEncoded));
      final optionsJson = json.decode(optionsJsonStr);

      // Извлекаем game_url
      final gameUrl = optionsJson['launch_options']['game_url'];
      if (gameUrl == null) {
        throw Exception('game_url не найден в launch_options');
      }

      // Извлекаем параметр params
      final gameUri = Uri.parse(gameUrl);
      final paramsEncoded = gameUri.queryParameters['params'];
      if (paramsEncoded == null) {
        throw Exception('Параметр params не найден в game_url');
      }

      // Декодируем params
      final paramsJsonStr = utf8.decode(base64.decode(paramsEncoded));
      final paramsJson = json.decode(paramsJsonStr);

      final tableId = paramsJson['table_id'];
      final vtId = paramsJson['vt_id'];
      final uaLaunchId = paramsJson['ua_launch_id'];
      final clientVersion = paramsJson['client_version'];

      if (tableId == null || vtId == null || clientVersion == null) {
        throw Exception('Некорректные параметры подключения');
      }

      // Формируем instance
      final random = Random().nextInt(1000000);
      final instance = '$random-$evoSessionId-$vtId';

      return WebSocketParams(
        tableId: tableId,
        vtId: vtId,
        uaLaunchId: uaLaunchId,
        clientVersion: clientVersion,
        evoSessionId: evoSessionId,
        instance: instance,
      );
    } catch (e) {
      Logger.error('Ошибка извлечения параметров WebSocket', e);
      rethrow;
    }
  }
}
