import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/ui/track-item.dart';

class TrackListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return FutureBuilder<List<TrackModel>>(
      future: api.fetchTracks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TrackList(
            tracks: snapshot.data,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
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
