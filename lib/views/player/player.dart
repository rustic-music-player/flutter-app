import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/media_bloc.dart';
import 'package:rustic/views/player/controls.dart';
import 'package:rustic/views/player/coverart.dart';
import 'package:rustic/views/player/queue.dart';

class PlayerView extends StatelessWidget {
  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).size.shortestSide < 600;
    var body;
    if (mobile) {
      body = Column(
        children: <Widget>[
          PlayerCoverArt(),
          PlayerMetadata(),
          PlayerControls(),
          PlayerVolumeControl(),
        ],
      );
    }else {
      body = Row(
        children: [
          PlayerCoverArt(),
          Expanded(
            child: Column(
              children: [
                PlayerMetadata(),
                PlayerControls(),
                PlayerVolumeControl()
              ],
            ),
          )
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        leading: ClosePlayerButton(),
        title: const Text("Now Playing"),
        centerTitle: true,
        actions: <Widget>[PlayerFavoriteButton(), PlayerQueueButton(false)],
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: body
    );
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
  PlayerMetadata({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(
      condition: (prev, next) => prev.track != next.track,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              state.track.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              state.track.artist?.name ?? "",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
