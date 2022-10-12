// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    PlaylistModel(
      cursor: json['cursor'] as String,
      title: json['title'] as String,
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => TrackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'title': instance.title,
      'tracks': instance.tracks,
    };
