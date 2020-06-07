import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/track.dart';

part 'playlist.g.dart';

@JsonSerializable()
class PlaylistModel {
  final String cursor;
  final String title;
  final List<TrackModel> tracks;

  PlaylistModel({this.cursor, this.title, this.tracks});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
