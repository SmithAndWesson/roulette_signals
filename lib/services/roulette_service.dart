import 'package:http/http.dart' as http;
import 'package:roulette_signals/models/roulette_game.dart';
import 'package:roulette_signals/models/websocket_params.dart';
import 'package:roulette_signals/utils/logger.dart';
import 'dart:convert';
import 'dart:math';

class RouletteService {
  static const String _baseUrl = 'https://gizbo.casino';
  static const String _gamesEndpoint = '/api/cms/v2/games/UAH';

  Future<List<RouletteGame>> fetchLiveRouletteGames() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_gamesEndpoint'));

      if (response.statusCode != 200) {
        throw Exception('Ошибка получения списка игр: ${response.statusCode}');
      }

      final List<dynamic> gamesJson = json.decode(response.body);
      final List<RouletteGame> rouletteGames = gamesJson
          .map((game) => RouletteGame.fromJson(game))
          .where((game) => game.collections.contains('live_roulette'))
          .toList();

      Logger.info('Получено ${rouletteGames.length} рулеток');
      return rouletteGames;
    } catch (e) {
      Logger.error('Ошибка при получении списка рулеток', e);
      rethrow;
    }
  }

  Future<WebSocketParams> extractWebSocketParams(
      String playUrl, String evoSessionId) async {
    try {
      // 1. Получаем HTML страницы
      final response = await http.get(Uri.parse(playUrl));
      if (response.statusCode != 200) {
        throw Exception('Ошибка получения страницы: ${response.statusCode}');
      }

      // 2. Извлекаем iframe и параметр options
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

      // 3. Декодируем и парсим options
      final optionsBase64 = optionsMatch.group(1)!;
      final optionsJson = utf8.decode(base64.decode(optionsBase64));
      final options = json.decode(optionsJson);

      // 4. Получаем game_url и параметр params
      final gameUrl = options['launch_options']['game_url'];
      final paramsPattern = RegExp(r'params=([^&]+)');
      final paramsMatch = paramsPattern.firstMatch(gameUrl);
      if (paramsMatch == null) {
        throw Exception('Не найден параметр params в game_url');
      }

      // 5. Декодируем и парсим params
      final paramsBase64 = paramsMatch.group(1)!;
      final paramsJson = utf8.decode(base64.decode(paramsBase64));
      final params = json.decode(paramsJson);

      // 6. Формируем instance
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
