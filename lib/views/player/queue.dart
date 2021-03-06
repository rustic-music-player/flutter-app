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
    final ServerBloc serverBloc = context.bloc();
    return BlocBuilder<QueueBloc, List<TrackModel>>(
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                leading: ClosePlayerButton(),
                title: const Text("Queue"),
                centerTitle: true,
                actions: <Widget>[PlayerQueueButton(true)],
                elevation: 0,
              ),
              backgroundColor: const Color.fromARGB(255, 32, 32, 32),
              body: ListView(
                children: state
                    .asMap()
                    .map((i, t) => MapEntry(
                        i,
                        TrackListItem(t,
                            onSelect: () =>
                                serverBloc.getApi().selectQueueItem(i))))
                    .values
                    .toList(),
              ),
            ));
  }
}
