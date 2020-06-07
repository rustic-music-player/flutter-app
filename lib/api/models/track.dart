import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';

part 'track.g.dart';

@JsonSerializable()
class TrackModel {
  final String title;
  final String cursor;
  final String provider;
  final String coverart;
  final AlbumModel album;
  final ArtistModel artist;
  final int duration;

  TrackModel(
      {this.title,
      this.cursor,
      this.provider,
      this.coverart,
      this.duration,
      this.artist,
      this.album});

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);
}
