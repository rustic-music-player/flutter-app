import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';

const stateChangedMsg = 'PLAYER_STATE_CHANGED';
const playingChangedMsg = 'CURRENTLY_PLAYING_CHANGED';
const volumeChangedMsg = 'VOLUME_CHANGED';

class FetchPlayer {}

class SetVolume {
  final double volume;

  SetVolume(this.volume);
}

class Playing {
  bool isPlaying;
  TrackModel track;
  double volume;

  Playing({this.isPlaying, this.track, this.volume});

  @override
  String toString() {
    return 'Playing { isPlaying: $isPlaying, track: $track, volume: $volume }';
  }
}

class CurrentMediaBloc extends Bloc<dynamic, Playing> {
  final ServerBloc serverBloc;
  StreamSubscription socketSubscription;

  CurrentMediaBloc({this.serverBloc}) {
    socketSubscription = serverBloc.events().listen((event) {
      this.add(event);
    });
  }

  @override
  Future<void> close() {
    socketSubscription.cancel();
    return super.close();
  }

  @override
  Playing get initialState =>
      Playing(isPlaying: false, track: null, volume: 1.0);

  @override
  Stream<Playing> mapEventToState(dynamic event) async* {
    if (event is SocketMessage) {
      yield handleSocketMessage(event);
    } else if (event is SetVolume) {
      yield Playing(
          isPlaying: state.isPlaying, track: state.track, volume: event.volume);
      await serverBloc.getApi().setVolume(state.volume);
    } else if (event is FetchPlayer) {
      var player = await serverBloc.getApi().getPlayer();
      yield Playing(
          isPlaying: player.playing,
          track: player.current,
          volume: player.volume);
    }
  }

  Playing handleSocketMessage(event) {
    switch (event.type) {
      case stateChangedMsg:
        var playing = event.payload as bool;
        return Playing(
            track: state.track, isPlaying: playing, volume: state.volume);
      case playingChangedMsg:
        var track = TrackModel.fromJson(event.payload);
        return Playing(
            isPlaying: state.isPlaying, track: track, volume: state.volume);
      case volumeChangedMsg:
        var volume = event.payload as double;
        return Playing(
            isPlaying: state.isPlaying, track: state.track, volume: volume);
    }
    return state;
  }
}
