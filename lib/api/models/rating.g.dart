// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      type: json['type'] as String,
      stars: json['stars'] as int?,
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'type': instance.type,
      'stars': instance.stars,
    };
