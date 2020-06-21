import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/state/media_bloc.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Api api = context.repository();

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
            onPressed: () => api.playerPrev(),
          ),
          PlayPauseButton(),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white),
            iconSize: 32,
            onPressed: () => api.playerNext(),
          ),
          IconButton(
              icon: Icon(
            Icons.repeat,
            color: Colors.white54,
          ))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ));
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Api api = context.repository();
    return BlocBuilder<CurrentMediaBloc, Playing>(
      condition: (prev, next) => prev.isPlaying != next.isPlaying,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Ink(
          decoration: const ShapeDecoration(
              shape: const CircleBorder(), color: Colors.deepOrange),
          child: IconButton(
            icon: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 56,
            onPressed: () =>
                state.isPlaying ? api.playerPause() : api.playerPlay(),
          ),
        ),
      ),
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
      condition: (prev, next) => prev.volume != next.volume,
      builder: (context, state) => Padding(
        child: Row(children: <Widget>[
          IconButton(
              icon: Icon(Icons.volume_down),
              onPressed: () => bloc.add(SetVolume(state.volume - 0.1))),
          Expanded(
              child: Slider(
            value: state.volume,
            divisions: 100,
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
