import 'package:freezed_annotation/freezed_annotation.dart';
import '../roulette/roulette_number.dart';

part 'websocket_message.freezed.dart';
part 'websocket_message.g.dart';

@freezed
class WebSocketMessage with _$WebSocketMessage {
  const WebSocketMessage._();

  const factory WebSocketMessage({
    required String type,
    required Map<String, dynamic> data,
  }) = _WebSocketMessage;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);

  bool get isRecentResults => type == 'roulette.recentResults';
  bool get isNewNumber => type == 'roulette.newNumber';

  List<RouletteNumber>? get recentNumbers {
    if (!isRecentResults) return null;
    final numbers = data['numbers'] as List<dynamic>;
    return numbers.map((n) => RouletteNumber.fromValue(n as int)).toList();
  }

  RouletteNumber? get newNumber {
    if (!isNewNumber) return null;
    final number = data['number'] as int;
    return RouletteNumber.fromValue(number);
  }

  @override
  String toString() => 'WebSocketMessage(type: $type)';
}
