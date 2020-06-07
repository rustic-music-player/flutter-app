import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/track.dart';

part 'player.g.dart';

@JsonSerializable()
class PlayerModel {
  final String cursor;
  final String name;
  final bool playing;
  final double volume;
  final TrackModel current;

  PlayerModel(
      {this.cursor, this.name, this.playing, this.volume, this.current});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
