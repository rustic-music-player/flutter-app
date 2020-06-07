// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) {
  return TrackModel(
      id: json['id'] as int,
      title: json['title'] as String,
      stream_url: json['stream_url'] as String,
      uri: json['uri'] as String,
      provider: json['provider'] as String,
      coverart: json['coverart'] as String,
      duration: json['duration'] as int);
}

Map<String, dynamic> _$TrackModelToJson(TrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'stream_url': instance.stream_url,
      'uri': instance.uri,
      'provider': instance.provider,
      'coverart': instance.coverart,
      'duration': instance.duration
    };
