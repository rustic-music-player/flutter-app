import 'package:json_annotation/json_annotation.dart';

part 'extension.g.dart';

@JsonSerializable()
class ExtensionModel {
  final String name;
  final String id;
  final String version;
  final bool enabled;
  final ExtensionControlsModel controls;

  ExtensionModel(
      {required this.name,
      required this.id,
      required this.version,
      required this.enabled,
      required this.controls});

  factory ExtensionModel.fromJson(Map<String, dynamic> json) =>
      _$ExtensionModelFromJson(json);

  @override
  String toString() {
    return 'ExtensionModel { id: $id, name: $name, version: $version, enabled: $enabled, controls: $controls }';
  }
}

@JsonSerializable()
class ExtensionControlsModel {
  final List<ExtensionActionModel> actions;
  final List<ExtensionInfoModel> infos;

  ExtensionControlsModel({ required this.actions, required this.infos });

  factory ExtensionControlsModel.fromJson(Map<String, dynamic> json) =>
      _$ExtensionControlsModelFromJson(json);
}

@JsonSerializable()
class ExtensionActionModel {
  final String key;
  final String label;

  ExtensionActionModel({ required this.key, required this.label });

  factory ExtensionActionModel.fromJson(Map<String, dynamic> json) =>
      _$ExtensionActionModelFromJson(json);
}

@JsonSerializable()
class ExtensionInfoModel {
  final String type;
  final String value;

  ExtensionInfoModel({ required this.type, required this.value });

  factory ExtensionInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ExtensionInfoModelFromJson(json);
}
