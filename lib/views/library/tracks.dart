import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/search-btn.dart';
import 'package:rustic/ui/track-item.dart';

class TracksView extends StatelessWidget {
  static const routeName = '/tracks';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) => FutureBuilder(
          future: state.current.getApi().fetchTracks(),
          builder: (context, snapshot) => Scaffold(
              drawer: RusticDrawer(),
              appBar: AppBar(
                  title: Text('Tracks'),
                  actions: <Widget>[SearchButton()],
                  bottom: snapshot.hasData
                      ? null
                      : PreferredSize(
                          child: LinearProgressIndicator(),
                          preferredSize: Size.fromHeight(4))),
              body: Column(children: <Widget>[
                Expanded(
                    child: TrackList(
                  tracks: snapshot.data ?? [],
                )),
                RusticPlayerBar()
              ]))),
    );
  }
}

class TrackList extends StatelessWidget {
  final List<TrackModel> tracks;

  TrackList({this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this.tracks.map<Widget>((t) => TrackListItem(t)).toList(),
    );
  }
}
