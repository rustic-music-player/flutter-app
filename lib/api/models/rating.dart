import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  static final None = 'none';
  static final Like = 'like';
  static final Dislike = 'dislike';
  static final Stars = 'stars';

  final String type;
  final int stars;

  Rating({this.type, this.stars});

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);

  @override
  String toString() {
    if (type == Rating.Stars) {
      return 'Rating { type: $type, stars: $stars }';
    }
    return 'Rating { type: $type }';
  }
}
