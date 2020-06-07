import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/track.dart';

part 'album.g.dart';

@JsonSerializable()
class AlbumModel {
  final String title;
  final String coverart;
  final String cursor;
  final ArtistModel artist;
  final List<TrackModel> tracks;

  AlbumModel(
      {this.cursor, this.title, this.coverart, this.tracks, this.artist});

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}
