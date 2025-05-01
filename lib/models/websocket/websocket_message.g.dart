// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketMessageImpl _$$WebSocketMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$WebSocketMessageImpl(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$WebSocketMessageImplToJson(
        _$WebSocketMessageImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };
