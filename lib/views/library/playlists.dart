import 'package:flutter/material.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/state/library/playlist_library_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/playlists/playlist-item.dart';
import 'package:rustic/ui/refreshable-list.dart';
import 'package:rustic/ui/search-btn.dart';

class PlaylistsView extends StatelessWidget {
  static const routeName = '/playlists';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(
          title: Text('Playlists'),
          actions: <Widget>[SearchButton()],
        ),
        body: Column(children: [
          Expanded(
              child: RefreshableList<PlaylistLibraryBloc, PlaylistModel>(
            builder: (context, playlist) => PlaylistListItem(playlist),
          )),
          RusticPlayerBar()
        ]));
  }
}
