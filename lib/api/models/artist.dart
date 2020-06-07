import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonSerializable()
class ArtistModel {
  final String cursor;
  final String name;
  final String image;

  ArtistModel({this.cursor, this.name, this.image});

  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);
}
