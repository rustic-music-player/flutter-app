import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/track.dart';

class TrackListItem extends StatelessWidget {
  final TrackModel track;

  TrackListItem(this.track);

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return ListTile(
      title: Text(track.title),
      onTap: () => api.queueTrack(track.cursor),
      leading: CircleAvatar(
          child: track.coverart == null
              ? Icon(Icons.album)
              : Image(image: api.fetchCoverart(track.coverart))),
    );
  }
}
