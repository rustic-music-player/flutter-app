import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/position.dart';
import 'package:rustic/api/models/rating.dart';

part 'track.g.dart';

@JsonSerializable()
class TrackModel {
  final String title;
  final String cursor;
  final String provider;
  final String? coverart;
  final AlbumModel? album;
  final ArtistModel? artist;
  final int? duration;
  final Rating? rating;
  final PositionModel? position;
  final bool? playing;

  TrackModel(
      {required this.title,
      required this.cursor,
      required this.provider,
      this.coverart,
      this.duration,
      this.artist,
      this.album,
      this.rating,
      this.position,
      this.playing});

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  bool get isFavorite {
    log('$rating');
    return this.rating?.type == Rating.Like;
  }
}
