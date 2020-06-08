import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/track-item.dart';

class AlbumViewArguments {
  final AlbumModel album;

  AlbumViewArguments(this.album);
}

class AlbumView extends StatelessWidget {
  static const routeName = '/album';

  @override
  Widget build(BuildContext context) {
    final AlbumViewArguments args = ModalRoute.of(context).settings.arguments;
    final Api api = context.repository<Api>();

    return Scaffold(
      appBar: AppBar(
          title: Text(args.album.title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => api.queueAlbum(args.album.cursor),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: args.album.tracks
                  .map<Widget>((t) => TrackListItem(t))
                  .toList(),
            ),
          ),
          RusticPlayerBar()
        ],
      ),
    );
  }
}
