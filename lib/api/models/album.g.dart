// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) {
  return AlbumModel(
      id: json['id'] as int,
      title: json['title'] as String,
      coverart: json['coverart'] as String,
      uri: json['uri'] as String,
      artist: json['artist'] == null
          ? null
          : ArtistModel.fromJson(json['artist'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverart': instance.coverart,
      'uri': instance.uri,
      'artist': instance.artist
    };
