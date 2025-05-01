// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roulette_number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouletteNumberImpl _$$RouletteNumberImplFromJson(Map<String, dynamic> json) =>
    _$RouletteNumberImpl(
      value: (json['value'] as num).toInt(),
      color: json['color'] as String,
      isEven: json['isEven'] as bool,
      isHigh: json['isHigh'] as bool,
    );

Map<String, dynamic> _$$RouletteNumberImplToJson(
        _$RouletteNumberImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'color': instance.color,
      'isEven': instance.isEven,
      'isHigh': instance.isHigh,
    };
