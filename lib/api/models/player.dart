import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/track.dart';

part 'player.g.dart';

enum RepeatMode { None, Single, All }

String encodeRepeatMode(RepeatMode mode) {
  return _$RepeatModeEnumMap[mode]!;
}

@JsonSerializable()
class PlayerModel {
  final String cursor;
  final String name;
  final bool playing;
  final double volume;
  final TrackModel? current;
  final RepeatMode repeat;

  PlayerModel(
      {required this.cursor,
      required this.name,
      required this.playing,
      required this.volume,
      this.current,
      required this.repeat});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
