import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rustic/api/models/player.dart';
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

class NextRepeatMode {}

class Playing {
  bool isPlaying;
  TrackModel track;
  double volume;
  RepeatMode repeat;
  Color primaryColor;

  Playing(
      {this.isPlaying,
      this.track,
      this.volume,
      this.repeat,
      this.primaryColor});

  @override
  String toString() {
    return 'Playing { isPlaying: $isPlaying, track: $track, volume: $volume, repeat: $repeat, primaryColor: $primaryColor }';
  }

  static Playing fromWith(Playing playing,
      {isPlaying, track, volume, repeat, primaryColor}) {
    return Playing(
        isPlaying: isPlaying ?? playing.isPlaying,
        track: track ?? playing.track,
        volume: volume ?? playing.volume,
        repeat: repeat ?? playing.repeat,
        primaryColor: primaryColor ?? playing.primaryColor);
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
  Playing get initialState => Playing(
      isPlaying: false, track: null, volume: 1.0, repeat: RepeatMode.None);

  @override
  Stream<Playing> mapEventToState(dynamic event) async* {
    if (event is SocketMessage) {
      yield await handleSocketMessage(event);
    } else if (event is SetVolume) {
      yield Playing.fromWith(state, volume: event.volume);
      await serverBloc.getApi().setVolume(state.volume);
    } else if (event is FetchPlayer) {
      var player = await serverBloc.getApi().getPlayer();
      var color = await getColor(player.current);
      yield Playing(
          isPlaying: player.playing,
          track: player.current,
          volume: player.volume,
          repeat: player.repeat,
          primaryColor: color);
    } else if (event is NextRepeatMode) {
      var next = getNextRepeatMode();
      await serverBloc.getApi().setRepeat(next);
      yield Playing.fromWith(state, repeat: next);
    }
  }

  Future<Playing> handleSocketMessage(event) async {
    switch (event.type) {
      case stateChangedMsg:
        var playing = event.payload as bool;
        return Playing.fromWith(state, isPlaying: playing);
      case playingChangedMsg:
        var track = TrackModel.fromJson(event.payload);
        var color = await getColor(track);
        return Playing.fromWith(state, track: track, primaryColor: color);
      case volumeChangedMsg:
        var volume = event.payload as double;
        return Playing.fromWith(state, volume: volume);
    }
    return state;
  }

  Future<Color> getColor(TrackModel track) async {
    Color color;
    if (track != null) {
      var palette = await PaletteGenerator.fromImageProvider(
          serverBloc.getApi().fetchCoverart(track.coverart));
      color = palette.vibrantColor?.color;
    }
    return color;
  }

  getNextRepeatMode() {
    var next;
    switch (state.repeat) {
      case RepeatMode.None:
        next = RepeatMode.All;
        break;
      case RepeatMode.All:
        next = RepeatMode.Single;
        break;
      case RepeatMode.Single:
        next = RepeatMode.None;
        break;
    }
    return next;
  }
}
