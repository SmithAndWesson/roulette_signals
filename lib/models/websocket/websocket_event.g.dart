// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectedImpl _$$ConnectedImplFromJson(Map<String, dynamic> json) =>
    _$ConnectedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ConnectedImplToJson(_$ConnectedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$DisconnectedImpl _$$DisconnectedImplFromJson(Map<String, dynamic> json) =>
    _$DisconnectedImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DisconnectedImplToJson(_$DisconnectedImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$ErrorImpl _$$ErrorImplFromJson(Map<String, dynamic> json) => _$ErrorImpl(
      json['message'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ErrorImplToJson(_$ErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$RecentNumbersImpl _$$RecentNumbersImplFromJson(Map<String, dynamic> json) =>
    _$RecentNumbersImpl(
      (json['numbers'] as List<dynamic>)
          .map((e) => RouletteNumber.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RecentNumbersImplToJson(_$RecentNumbersImpl instance) =>
    <String, dynamic>{
      'numbers': instance.numbers,
      'runtimeType': instance.$type,
    };

_$NewNumberImpl _$$NewNumberImplFromJson(Map<String, dynamic> json) =>
    _$NewNumberImpl(
      RouletteNumber.fromJson(json['number'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NewNumberImplToJson(_$NewNumberImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'runtimeType': instance.$type,
    };
