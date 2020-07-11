// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) {
  return AlbumModel(
    cursor: json['cursor'] as String,
    title: json['title'] as String,
    coverart: json['coverart'] as String,
    provider: json['provider'] as String,
    tracks: (json['tracks'] as List)
        ?.map((e) =>
            e == null ? null : TrackModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    artist: json['artist'] == null
        ? null
        : ArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
    explicit: json['explicit'] as bool,
    inLibrary: json['inLibrary'] as bool,
  );
}

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'coverart': instance.coverart,
      'cursor': instance.cursor,
      'provider': instance.provider,
      'inLibrary': instance.inLibrary,
      'explicit': instance.explicit,
      'artist': instance.artist,
      'tracks': instance.tracks,
    };
