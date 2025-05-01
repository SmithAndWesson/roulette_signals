import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_params.freezed.dart';
part 'websocket_params.g.dart';

@freezed
class WebSocketParams with _$WebSocketParams {
  const WebSocketParams._();

  const factory WebSocketParams({
    required String tableId,
    required String vtId,
    required String uaLaunchId,
    required String clientVersion,
    required String evoSessionId,
    required String instance,
    required String cookieHeader,
  }) = _WebSocketParams;

  factory WebSocketParams.fromJson(Map<String, dynamic> json) =>
      _$WebSocketParamsFromJson(json);

  String get webSocketUrl {
    return 'wss://royal.evo-games.com/public/roulette/player/game/$tableId/socket'
        '?messageFormat=json'
        '&tableConfig=$vtId'
        '&EVOSESSIONID=$evoSessionId'
        '&client_version=$clientVersion'
        '&instance=$instance';
  }
}
