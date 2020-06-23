import 'package:flutter/material.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/views/library/playlist.dart';

class PlaylistListItem extends StatelessWidget {
  final PlaylistModel playlist;

  PlaylistListItem(this.playlist);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.title),
      onTap: () => Navigator.pushNamed(context, PlaylistView.routeName,
          arguments: PlaylistViewArguments(playlist)),
    );
  }
}
