// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketParamsImpl _$$WebSocketParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$WebSocketParamsImpl(
      tableId: json['tableId'] as String,
      vtId: json['vtId'] as String,
      uaLaunchId: json['uaLaunchId'] as String,
      clientVersion: json['clientVersion'] as String,
      evoSessionId: json['evoSessionId'] as String,
      instance: json['instance'] as String,
      cookieHeader: json['cookieHeader'] as String,
    );

Map<String, dynamic> _$$WebSocketParamsImplToJson(
        _$WebSocketParamsImpl instance) =>
    <String, dynamic>{
      'tableId': instance.tableId,
      'vtId': instance.vtId,
      'uaLaunchId': instance.uaLaunchId,
      'clientVersion': instance.clientVersion,
      'evoSessionId': instance.evoSessionId,
      'instance': instance.instance,
      'cookieHeader': instance.cookieHeader,
    };
