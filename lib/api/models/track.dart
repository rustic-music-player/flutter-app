import 'package:json_annotation/json_annotation.dart';

part 'track.g.dart';

@JsonSerializable()
class TrackModel {
  final int id;
  final String title;
  final String stream_url;
  final String uri;
  final String provider;
  final String coverart;
  final int duration;

  TrackModel(
      {this.id,
      this.title,
      this.stream_url,
      this.uri,
      this.provider,
      this.coverart,
      this.duration});

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);
}
