// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableProviderModel _$AvailableProviderModelFromJson(
    Map<String, dynamic> json) {
  return AvailableProviderModel(
    title: json['title'] as String,
    provider: json['provider'] as String,
    enabled: json['enabled'] as bool,
    authState: json['authState'],
  );
}

Map<String, dynamic> _$AvailableProviderModelToJson(
        AvailableProviderModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'provider': instance.provider,
      'enabled': instance.enabled,
      'authState': instance.authState,
    };

AuthStateModel _$AuthStateModelFromJson(Map<String, dynamic> json) {
  return AuthStateModel(
    state: json['state'] as String,
  );
}

Map<String, dynamic> _$AuthStateModelToJson(AuthStateModel instance) =>
    <String, dynamic>{
      'state': instance.state,
    };
