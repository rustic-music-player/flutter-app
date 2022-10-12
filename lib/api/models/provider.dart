import 'package:json_annotation/json_annotation.dart';

part 'provider.g.dart';

const AuthStateAuthenticated = 'authenticated';

@JsonSerializable()
class AvailableProviderModel {
  final String title;
  final String provider;
  final bool enabled;
  late AuthStateModel authState;

  AvailableProviderModel({required this.title, required this.provider, required this.enabled, authState}) {
    this.authState = AuthStateModel.fromJson(authState);
  }

  factory AvailableProviderModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableProviderModelFromJson(json);
}

@JsonSerializable()
class AuthStateModel {
  static final Authenticated = 'authenticated';
  static final PasswordAuth = 'password-authentication';
  static final NoAuthentication = 'no-authentication';

  final String state;

  AuthStateModel({required this.state});

  factory AuthStateModel.fromJson(Map<String, dynamic> json) =>
      _$AuthStateModelFromJson(json);
}
