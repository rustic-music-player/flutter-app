import 'package:json_annotation/json_annotation.dart';

part 'open_result.g.dart';

@JsonSerializable()
class OpenResultModel {
  final String cursor;
  final String type;

  OpenResultModel({required this.cursor, required this.type});

  factory OpenResultModel.fromJson(Map<String, dynamic> json) =>
      _$OpenResultModelFromJson(json);

  @override
  String toString() {
    return 'OpenResultModel { cursor: $cursor, type: $type }';
  }
}
