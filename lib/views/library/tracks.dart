import 'package:flutter/material.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/library/track_library_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/refreshable-list.dart';
import 'package:rustic/ui/search-btn.dart';
import 'package:rustic/ui/track-item.dart';

class TracksView extends StatelessWidget {
  static const routeName = '/tracks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: RusticDrawer(),
        appBar:
            AppBar(title: Text('Tracks'), actions: <Widget>[SearchButton()]),
        body: Column(children: <Widget>[
          Expanded(
              child: RefreshableList<TrackLibraryBloc, TrackModel>(
                  builder: (context, track) => TrackListItem(track))),
          RusticPlayerBar()
        ]));
  }
}

class TrackList extends StatelessWidget {
  final List<TrackModel> tracks;

  TrackList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, i) => TrackListItem(tracks[i]),
    );
  }
}
