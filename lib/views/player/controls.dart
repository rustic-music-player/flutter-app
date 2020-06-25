import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/player.dart';
import 'package:rustic/state/media_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ServerBloc bloc = context.bloc();

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(
            Icons.shuffle,
            color: Colors.white54,
          )),
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: Colors.white,
            ),
            iconSize: 32,
            onPressed: () => bloc.getApi().playerPrev(),
          ),
          PlayPauseButton(),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white),
            iconSize: 32,
            onPressed: () => bloc.getApi().playerNext(),
          ),
          RepeatButton()
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ));
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(builder: (context, state) {
      CurrentMediaBloc bloc = context.bloc();
      return IconButton(
          icon: getIcon(state), onPressed: () => bloc.add(NextRepeatMode()));
    });
  }

  getIcon(Playing state) {
    var icon;
    switch (state.repeat) {
      case RepeatMode.None:
        icon = Icon(
          Icons.repeat,
          color: Colors.white54,
        );
        break;
      case RepeatMode.All:
        icon = Icon(Icons.repeat, color: state.primaryColor);
        break;
      case RepeatMode.Single:
        icon = Icon(Icons.repeat_one, color: state.primaryColor);
        break;
    }
    return icon;
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServerBloc server = context.bloc();
    return BlocBuilder<CurrentMediaBloc, Playing>(
      condition: (prev, next) =>
      prev.isPlaying != next.isPlaying ||
          prev.primaryColor != next.primaryColor,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Ink(
              decoration: ShapeDecoration(
                  shape: CircleBorder(), color: state.primaryColor),
              child: IconButton(
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 56,
                onPressed: () =>
                state.isPlaying
                    ? server.getApi().playerPause()
                    : server.getApi().playerPlay(),
              ),
            ));
      },
    );
  }
}

class PlayerVolumeControl extends StatelessWidget {
  const PlayerVolumeControl({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentMediaBloc bloc = context.bloc();
    return BlocBuilder<CurrentMediaBloc, Playing>(
      condition: (prev, next) =>
      prev.volume != next.volume || prev.primaryColor != next.primaryColor,
      builder: (context, state) =>
          Padding(
            child: Row(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.volume_down),
                  onPressed: () => bloc.add(SetVolume(state.volume - 0.1))),
              Expanded(
                  child: Slider(
                    value: state.volume,
                    divisions: 100,
                    activeColor: state.primaryColor,
                    onChanged: (volume) => bloc.add(SetVolume(volume)),
                  )),
              IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () => bloc.add(SetVolume(state.volume + 0.1))),
            ]),
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
          ),
    );
  }
}
