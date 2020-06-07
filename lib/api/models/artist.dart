import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonSerializable()
class ArtistModel {
  final int id;
  final String name;
  final String uri;
  final String image;

  ArtistModel({this.id, this.name, this.image, this.uri});

  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);
}
