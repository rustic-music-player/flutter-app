import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;

  PlayerControls(this.isPlaying);

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
          PlayPauseButton(isPlaying: isPlaying),
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
    @required this.isPlaying,
  }) : super(key: key);

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    Api api = context.repository();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Ink(
        decoration: const ShapeDecoration(
            shape: const CircleBorder(), color: Colors.deepOrange),
        child: IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          iconSize: 56,
          onPressed: () => isPlaying ? api.playerPause() : api.playerPlay(),
        ),
      ),
    );
  }
}

class PlayerPlaybackControl extends StatelessWidget {
  const PlayerPlaybackControl({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Slider(value: 0),
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
    );
  }
}
