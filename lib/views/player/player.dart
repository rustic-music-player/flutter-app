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
          Expanded(child: PlayerCoverArt()),
          NowPlaying(),
          PlayerControls(),
          PlayerVolumeControl(),
        ],
      );
    } else {
      body = Row(
        children: [
          Flexible(
            child: Column(children: [
              Expanded(child: PlayerCoverArt()),
              NowPlaying(),
              PlayerControls(),
              PlayerVolumeControl()
            ]),
          ),
          Flexible(flex: 2, child: Column(
            children: [
              Text("Queue"),
              Expanded(child: Queue()),
            ],
          ))
        ],
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          leading: ClosePlayerButton(),
          title: const Text("Now Playing"),
          centerTitle: true,
          actions: mobile ? [PlayerQueueButton(false)] : [],
          elevation: 0,
        ),
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        body: body);
  }
}

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          PlayerFavoriteButton(),
          PlayerMetadata(),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ]),
      );
  }
}


class ClosePlayerButton extends StatelessWidget {
  const ClosePlayerButton({
    Key? key,
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
    Key? key,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(
      builder: (context, state) => IconButton(
          icon: state.track?.isFavorite ?? false
              ? const Icon(Icons.favorite, color: Colors.white)
              : const Icon(Icons.favorite_border, color: Colors.white54), onPressed: () {},),
    );
  }
}

class PlayerMetadata extends StatelessWidget {
  PlayerMetadata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(
      buildWhen: (prev, next) => prev.track != next.track,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              state.track?.title ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              state.track?.artist?.name ?? "",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
