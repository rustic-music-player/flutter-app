import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/queue_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/track-item.dart';
import 'package:rustic/views/player/player.dart';

class QueueView extends StatelessWidget {
  static const routeName = '/player/queue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        leading: ClosePlayerButton(),
        title: const Text("Queue"),
        centerTitle: true,
        actions: [PlayerQueueButton(true)],
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Queue(),
    );
  }
}

class Queue extends StatelessWidget {
  const Queue({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServerBloc serverBloc = context.read();

    return BlocBuilder<QueueBloc, List<TrackModel>>(builder: (context, tracks) {
      return ListView(
        children: tracks
            .asMap()
            .map((i, t) => MapEntry(
                i, TrackListItem(t, onSelect: () => serverBloc.getApi()?.selectQueueItem(i))))
            .values
            .toList(),
      );
    });
  }
}
