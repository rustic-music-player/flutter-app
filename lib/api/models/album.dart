import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/artist.dart';

part 'album.g.dart';

@JsonSerializable()
class AlbumModel {
  final int id;
  final String title;
  final String coverart;
  final String uri;
  final ArtistModel artist;

  AlbumModel({this.id, this.title, this.coverart, this.uri, this.artist});

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}
