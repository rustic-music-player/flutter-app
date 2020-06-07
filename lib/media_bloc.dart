import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';

const stateChangedMsg = 'PLAYER_STATE_CHANGED';
const playingChangedMsg = 'CURRENTLY_PLAYING_CHANGED';

class FetchPlayers {}

class Playing {
  bool isPlaying;
  TrackModel track;

  Playing({this.isPlaying, this.track});

  @override
  String toString() {
    return 'Playing { isPlaying: $isPlaying, track: $track }';
  }
}

class CurrentMediaBloc extends Bloc<dynamic, Playing> {
  final Api api;
  StreamSubscription socketSubscription;

  CurrentMediaBloc({this.api}) {
    socketSubscription = api.messages().listen((event) {
      this.add(event);
    });
  }

  @override
  Future<void> close() {
    socketSubscription.cancel();
    return super.close();
  }

  @override
  Playing get initialState => Playing(isPlaying: false, track: null);

  @override
  Stream<Playing> mapEventToState(dynamic event) async* {
    if (event is SocketMessage) {
      yield handleSocketMessage(event);
    } else {
      var player = await api.getPlayer();
      yield Playing(isPlaying: player.playing, track: player.current);
    }
  }

  Playing handleSocketMessage(event) {
    switch (event.type) {
      case stateChangedMsg:
        var playing = event.payload as bool;
        return Playing(track: state.track, isPlaying: playing);
      case playingChangedMsg:
        var track = TrackModel.fromJson(event.payload);
        return Playing(isPlaying: state.isPlaying, track: track);
    }
    return state;
  }
}
