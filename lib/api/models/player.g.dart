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
    repeat: _$enumDecodeNullable(_$RepeatModeEnumMap, json['repeat']),
  );
}

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'name': instance.name,
      'playing': instance.playing,
      'volume': instance.volume,
      'current': instance.current,
      'repeat': _$RepeatModeEnumMap[instance.repeat],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RepeatModeEnumMap = {
  RepeatMode.None: 'None',
  RepeatMode.Single: 'Single',
  RepeatMode.All: 'All',
};
