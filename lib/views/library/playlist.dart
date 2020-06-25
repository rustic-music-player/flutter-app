import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/views/library/tracks.dart';

class PlaylistViewArguments {
  final PlaylistModel playlist;

  PlaylistViewArguments(this.playlist);
}

class PlaylistView extends StatelessWidget {
  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    final PlaylistViewArguments args =
        ModalRoute.of(context).settings.arguments;
    final ServerBloc bloc = context.bloc();

    return Scaffold(
      appBar: AppBar(
          title: Text(args.playlist.title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_play),
        onPressed: () => bloc.getApi().queuePlaylist(args.playlist.cursor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        children: <Widget>[
          Expanded(child: TrackList(tracks: args.playlist.tracks)),
          RusticPlayerBar()
        ],
      ),
    );
  }
}
