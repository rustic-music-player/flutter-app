import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/media_bloc.dart';
import 'package:rustic/views/player/controls.dart';
import 'package:rustic/views/player/coverart.dart';
import 'package:rustic/views/player/queue.dart';

class PlayerView extends StatelessWidget {
  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                leading: ClosePlayerButton(),
                title: const Text("Now Playing"),
                centerTitle: true,
                actions: <Widget>[
                  PlayerFavoriteButton(),
                  PlayerQueueButton(false)
                ],
                elevation: 0,
              ),
              backgroundColor: const Color.fromARGB(255, 32, 32, 32),
              body: Column(
                children: <Widget>[
                  PlayerCoverArt(state.track.coverart),
                  PlayerMetadata(state.track),
                  PlayerControls(state.isPlaying),
                  PlayerPlaybackControl(),
                ],
              ),
            ));
  }
}

class ClosePlayerButton extends StatelessWidget {
  const ClosePlayerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}

class PlayerQueueButton extends StatelessWidget {
  final bool isOpen;

  const PlayerQueueButton(
    this.isOpen, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.queue_music, color: Colors.white),
      onPressed: () {
        if (isOpen) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(context, QueueView.routeName);
        }
      },
    );
  }
}

class PlayerFavoriteButton extends StatelessWidget {
  const PlayerFavoriteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.favorite_border, color: Colors.white54));
  }
}

class PlayerMetadata extends StatelessWidget {
  final TrackModel track;

  PlayerMetadata(this.track, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          track.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(track.artist?.name ?? "")
      ],
    );
  }
}
