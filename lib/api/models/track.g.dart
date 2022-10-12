// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) => TrackModel(
      title: json['title'] as String,
      cursor: json['cursor'] as String,
      provider: json['provider'] as String,
      coverart: json['coverart'] as String?,
      duration: json['duration'] as int?,
      artist: json['artist'] == null
          ? null
          : ArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
      album: json['album'] == null
          ? null
          : AlbumModel.fromJson(json['album'] as Map<String, dynamic>),
      rating: json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      position: json['position'] == null
          ? null
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackModelToJson(TrackModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'cursor': instance.cursor,
      'provider': instance.provider,
      'coverart': instance.coverart,
      'album': instance.album,
      'artist': instance.artist,
      'duration': instance.duration,
      'rating': instance.rating,
      'position': instance.position,
    };
