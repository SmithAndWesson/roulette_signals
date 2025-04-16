import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/utils/logger.dart';
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

      final filteredGames = rouletteGames
          .where((game) =>
              !restrictedGames.contains(game.identifier) &&
              !restrictedProviders.contains(game.provider))
          .toList();

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
      final response = await http.get(
        Uri.parse('https://gizbo.casino$playUrl'),
        headers: {
          'Cookie':
              'statapi_client_id=17435192178550976; first_visit_sended=1743519217856; _ga=GA1.1.671593745.1743519218; statapi_device_id=17435192190333592; original_user_id=eyJfcmFpbHMiOnsibWVzc2FnZSI6Ik1USTJNell3TVE9PSIsImV4cCI6bnVsbCwicHVyIjoiY29va2llLm9yaWdpbmFsX3VzZXJfaWQifX0%3D--bce4ff7d4e075c9acd46c4d2cb24e3aa300ef1b0; user_id=1263601; solLanguage=en; urexp=eyJhc3NpZ25lZCI6eyIyNjMiOnsib3B0aW9uIjowLCJ2ZXJzaW9uIjowfX0sInVwZCI6dHJ1ZX0=; notificationDate=1744818352678; statapi_session_id=1744737605517; _ga=GA1.1.671593745.1743519218; version=522261; __cf_bm=0MY1.9kLNTAGKAzXZjPOnL8C7qOUd2e05TJPLGD82v4-1744741450-1.0.1.1-pIGa4R.SYz37itEc6sSY9In7Nml7TRMw9p9on99OeNYaQbp.VyOjdL2BtznD9V1Mj.vNkphaQzALpp6YxgkUFq8slI_GOIGIAR.akzJsIfs; domain_manager_session=eyJpdiI6ImYxWkNoc2dydm0xeU92XC95OVBGRGh3PT0iLCJ2YWx1ZSI6IndNN2MycUl0enMwSXFwZlBha3dJVUdPWjBNWGhLaFV1MGJQeE56NlpodjJQcGdlQTJ0RzN0T01RSk5xUjFSVGYiLCJtYWMiOiI2M2E0N2Y4ODQ1Yzk0YjZiMTYyZDBiY2FmZTFhMzJlNWRiZWE3NWQzODc0M2Q3N2FlMGEyMWEwMzRjMGVhMmMxIn0%3D; _ga_2LS3EW1NFC=GS1.1.1744737605.7.1.1744742290.0.0.0; _casino_session=fd8e11d239dab79528b7540ed364e32e', // полный набор как в браузере
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Ошибка получения страницы: ${response.statusCode}');
      }

      final iframePattern = RegExp(r'<iframe[^>]*src="([^"]*)"');
      final iframeMatch = iframePattern.firstMatch(response.body);
      if (iframeMatch == null) {
        throw Exception('Не найден iframe на странице');
      }

      final iframeUrl = iframeMatch.group(1)!;
      final optionsPattern = RegExp(r'options=([^&]+)');
      final optionsMatch = optionsPattern.firstMatch(iframeUrl);
      if (optionsMatch == null) {
        throw Exception('Не найден параметр options в URL iframe');
      }

      final optionsBase64 = optionsMatch.group(1)!;
      final optionsJson = utf8.decode(base64.decode(optionsBase64));
      final options = json.decode(optionsJson);

      final gameUrl = options['launch_options']['game_url'];
      final paramsPattern = RegExp(r'params=([^&]+)');
      final paramsMatch = paramsPattern.firstMatch(gameUrl);
      if (paramsMatch == null) {
        throw Exception('Не найден параметр params в game_url');
      }

      final paramsBase64 = paramsMatch.group(1)!;
      final paramsJson = utf8.decode(base64.decode(paramsBase64));
      final params = json.decode(paramsJson);

      final random = Random().nextInt(1000000);
      final instance = '$random-$evoSessionId-${params['vt_id']}';

      return WebSocketParams(
        tableId: params['table_id'],
        vtId: params['vt_id'],
        uaLaunchId: params['ua_launch_id'],
        clientVersion: params['client_version'],
        evoSessionId: evoSessionId,
        instance: instance,
      );
    } catch (e) {
      Logger.error('Ошибка извлечения параметров WebSocket', e);
      rethrow;
    }
  }
}
