import 'package:flutter/material.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/ui/playlists/playlist-item.dart';

class PlaylistList extends StatelessWidget {
  final List<PlaylistModel> playlists;

  PlaylistList({this.playlists});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children:
          this.playlists.map((playlist) => PlaylistListItem(playlist)).toList(),
    );
  }
}