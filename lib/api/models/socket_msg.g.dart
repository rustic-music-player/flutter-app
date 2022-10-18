// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketMessage _$SocketMessageFromJson(Map<String, dynamic> json) =>
    SocketMessage(
      playerCursor: json['player_cursor'] as String?,
      type: json['type'] as String,
      payload: json['payload'],
    );

Map<String, dynamic> _$SocketMessageToJson(SocketMessage instance) =>
    <String, dynamic>{
      'player_cursor': instance.playerCursor,
      'type': instance.type,
      'payload': instance.payload,
    };
