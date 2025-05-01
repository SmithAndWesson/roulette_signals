import 'package:freezed_annotation/freezed_annotation.dart';
import '../roulette/roulette_number.dart';

part 'websocket_event.freezed.dart';
part 'websocket_event.g.dart';

@freezed
class WebSocketEvent with _$WebSocketEvent {
  const factory WebSocketEvent.connected() = _Connected;
  const factory WebSocketEvent.disconnected() = _Disconnected;
  const factory WebSocketEvent.error(String message) = _Error;
  const factory WebSocketEvent.recentNumbers(List<RouletteNumber> numbers) =
      _RecentNumbers;
  const factory WebSocketEvent.newNumber(RouletteNumber number) = _NewNumber;

  factory WebSocketEvent.fromJson(Map<String, dynamic> json) =>
      _$WebSocketEventFromJson(json);
}
