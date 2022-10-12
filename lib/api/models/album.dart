import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/track.dart';

part 'album.g.dart';

@JsonSerializable()
class AlbumModel {
  final String title;
  final String? coverart;
  final String cursor;
  final String? provider;
  final bool? inLibrary;
  final bool? explicit;
  final ArtistModel? artist;
  final List<TrackModel> tracks;

  AlbumModel(
      {required this.cursor,
      required this.title,
      this.coverart,
      this.provider,
      required this.tracks,
      this.artist,
      this.explicit,
      this.inLibrary});

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  @override
  String toString() {
    return 'AlbumModel { title: $title, coverart: $coverart, cursor: $cursor, artist: $artist, tracks: $tracks, inLibrary: $inLibrary, explicit: $explicit }';
  }
}
