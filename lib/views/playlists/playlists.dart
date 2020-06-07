import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/ui/drawer.dart';

class PlaylistsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(title: Text('Playlists')),
        body: FutureBuilder<List<PlaylistModel>>(
          future: api.fetchPlaylists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PlaylistList(
                playlists: snapshot.data,
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ));
  }
}

class PlaylistList extends StatelessWidget {
  final List<PlaylistModel> playlists;

  PlaylistList({this.playlists});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .playlists
          .map<Widget>((p) => PlaylistListItem(
                playlist: p,
              ))
          .toList(),
    );
  }
}

class PlaylistListItem extends StatelessWidget {
  final PlaylistModel playlist;

  PlaylistListItem({this.playlist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.title),
    );
  }
}
