import 'package:flutter/material.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/track.dart';

class TrackListView extends StatelessWidget {
  final Api api;

  TrackListView({this.api});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackModel>>(
      future: api.fetchTracks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TrackList(
            tracks: snapshot.data,
            api: api,
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
  final Api api;

  TrackList({this.tracks, this.api});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .tracks
          .map<Widget>((a) => TrackListItem(
        api: api,
        track: a,
      ))
          .toList(),
    );
  }
}

class TrackListItem extends StatelessWidget {
  final TrackModel track;
  final Api api;

  TrackListItem({this.track, this.api});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.title),
      leading: CircleAvatar(child: api.fetchCoverart(track)),
    );
  }
}