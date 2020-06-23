import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';

class TrackListItem extends StatelessWidget {
  final TrackModel track;

  TrackListItem(this.track);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.bloc();
    return ListTile(
      title: Text(track.title),
      onTap: () => bloc.getApi().queueTrack(track.cursor),
      leading: CircleAvatar(
          child: track.coverart == null
              ? Icon(Icons.album)
              : Image(image: bloc.getApi().fetchCoverart(track.coverart))),
    );
  }
}
