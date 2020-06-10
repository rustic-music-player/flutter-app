import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/queue_bloc.dart';
import 'package:rustic/views/player/player.dart';

class QueueView extends StatelessWidget {
  static const routeName = '/player/queue';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueueBloc, List<TrackModel>>(builder: (context, state) {
      print(state);
      return Scaffold(
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
          children: state.map((t) => ListTile(title: Text(t.title))).toList(),
        ),
      );
    });
  }
}
