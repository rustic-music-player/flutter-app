import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/track.dart';

part 'playlist.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String cursor;
  final String title;
  final List<TrackModel> tracks;

  PlaylistModel({required this.cursor, required this.title, required this.tracks});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
