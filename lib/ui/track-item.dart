import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/coverart.dart';

class TrackListItem extends StatelessWidget {
  final TrackModel track;
  final VoidCallback? onSelect;

  TrackListItem(this.track, {this.onSelect});

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.read();
    return ListTile(
      selected: track.playing ?? false,
      trailing: track.playing == true ? Icon(Icons.music_note) : null,
      title: Text(track.title),
      subtitle: track.artist != null ? Text(track.artist!.name) : null,
      onTap: () {
        if (onSelect != null) {
          onSelect!();
        } else {
          bloc.getApi()?.queueTrack(track.cursor);
        }
      },
      leading: CircleAvatar(
          child: track.coverart == null
              ? Icon(Icons.album)
              : ClipRRect(
                  borderRadius: const BorderRadius.all(const Radius.circular(2)),
                  child: Coverart(track: track))),
    );
  }
}
