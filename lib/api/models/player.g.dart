// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return PlayerModel(
    cursor: json['cursor'] as String,
    name: json['name'] as String,
    playing: json['playing'] as bool,
    volume: (json['volume'] as num)?.toDouble(),
    current: json['current'] == null
        ? null
        : TrackModel.fromJson(json['current'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'name': instance.name,
      'playing': instance.playing,
      'volume': instance.volume,
      'current': instance.current,
    };
