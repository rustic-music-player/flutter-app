import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/playlists/playlist-list.dart';
import 'package:rustic/ui/search-btn.dart';

class PlaylistsView extends StatelessWidget {
  static const routeName = '/playlists';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(builder: (context, state) {
      var api = state.current.getApi();
      return FutureBuilder<List<PlaylistModel>>(
          future: api.fetchPlaylists(),
          builder: (context, snapshot) {
            return Scaffold(
                drawer: RusticDrawer(),
                appBar: AppBar(
                    title: Text('Playlists'),
                    actions: <Widget>[SearchButton()],
                    bottom: snapshot.hasData
                        ? null
                        : PreferredSize(
                            child: LinearProgressIndicator(),
                            preferredSize: Size.fromHeight(4))),
                body: Column(children: <Widget>[
                  Expanded(
                      child: ListView(children: <Widget>[
                    PlaylistList(
                      playlists: snapshot.data ?? [],
                    )
                  ])),
                  RusticPlayerBar()
                ]));
          });
    });
  }
}
