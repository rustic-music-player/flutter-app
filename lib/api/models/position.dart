import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

@JsonSerializable()
class PositionModel {
  final int track;
  final int disc;

  PositionModel({this.track, this.disc});

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);
}
