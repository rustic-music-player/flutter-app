import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/track.dart';

part 'search.g.dart';

@JsonSerializable()
class SearchResultModel {
  final List<TrackModel> tracks;
  final List<AlbumModel> albums;
  final List<ArtistModel> artists;

  SearchResultModel({this.tracks, this.albums, this.artists});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);
}
