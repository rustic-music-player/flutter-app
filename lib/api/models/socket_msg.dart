import 'package:json_annotation/json_annotation.dart';

part 'socket_msg.g.dart';

@JsonSerializable()
class SocketMessage {
  @JsonKey(name: 'player_cursor')
  final String? playerCursor;
  final String type;
  final dynamic payload;

  SocketMessage({required this.playerCursor, required this.type, this.payload});

  factory SocketMessage.fromJson(Map<String, dynamic> json) =>
      _$SocketMessageFromJson(json);

  @override
  String toString() {
    return 'SocketMessage { playerCursor: $playerCursor, type: $type, payload: $payload }';
  }
}
