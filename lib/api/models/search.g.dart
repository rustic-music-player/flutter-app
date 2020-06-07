// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) {
  return SearchResultModel(
    tracks: (json['tracks'] as List)
        ?.map((e) =>
            e == null ? null : TrackModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    albums: (json['albums'] as List)
        ?.map((e) =>
            e == null ? null : AlbumModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    artists: (json['artists'] as List)
        ?.map((e) =>
            e == null ? null : ArtistModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    playlists: (json['playlists'] as List)
        ?.map((e) => e == null
            ? null
            : PlaylistModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
      'albums': instance.albums,
      'artists': instance.artists,
      'playlists': instance.playlists,
    };
