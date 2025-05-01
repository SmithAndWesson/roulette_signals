import 'package:freezed_annotation/freezed_annotation.dart';

part 'roulette_number.freezed.dart';
part 'roulette_number.g.dart';

@freezed
class RouletteNumber with _$RouletteNumber {
  const factory RouletteNumber({
    required int value,
    required String color,
    required bool isEven,
    required bool isHigh,
  }) = _RouletteNumber;

  factory RouletteNumber.fromJson(Map<String, dynamic> json) =>
      _$RouletteNumberFromJson(json);

  factory RouletteNumber.fromValue(int value) {
    final color = _getColor(value);
    final isEven = value % 2 == 0;
    final isHigh = value > 18;

    return RouletteNumber(
      value: value,
      color: color,
      isEven: isEven,
      isHigh: isHigh,
    );
  }

  static String _getColor(int value) {
    if (value == 0) return 'green';

    final redNumbers = [
      1,
      3,
      5,
      7,
      9,
      12,
      14,
      16,
      18,
      19,
      21,
      23,
      25,
      27,
      30,
      32,
      34,
      36
    ];
    return redNumbers.contains(value) ? 'red' : 'black';
  }

  @override
  String toString() => 'RouletteNumber(value: $value, color: $color)';
}
