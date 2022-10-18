// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtensionModel _$ExtensionModelFromJson(Map<String, dynamic> json) =>
    ExtensionModel(
      name: json['name'] as String,
      id: json['id'] as String,
      version: json['version'] as String,
      enabled: json['enabled'] as bool,
      controls: ExtensionControlsModel.fromJson(
          json['controls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExtensionModelToJson(ExtensionModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'version': instance.version,
      'enabled': instance.enabled,
      'controls': instance.controls,
    };

ExtensionControlsModel _$ExtensionControlsModelFromJson(
        Map<String, dynamic> json) =>
    ExtensionControlsModel(
      actions: (json['actions'] as List<dynamic>)
          .map((e) => ExtensionActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      infos: (json['infos'] as List<dynamic>)
          .map((e) => ExtensionInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExtensionControlsModelToJson(
        ExtensionControlsModel instance) =>
    <String, dynamic>{
      'actions': instance.actions,
      'infos': instance.infos,
    };

ExtensionActionModel _$ExtensionActionModelFromJson(
        Map<String, dynamic> json) =>
    ExtensionActionModel(
      key: json['key'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$ExtensionActionModelToJson(
        ExtensionActionModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
    };

ExtensionInfoModel _$ExtensionInfoModelFromJson(Map<String, dynamic> json) =>
    ExtensionInfoModel(
      type: json['type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ExtensionInfoModelToJson(ExtensionInfoModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };
