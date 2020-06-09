import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/views/album/album.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;

  AlbumCard(this.album);

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return FractionallySizedBox(
        widthFactor: .5,
        child: Card(
          child: FlatButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Navigator.pushNamed(context, AlbumView.routeName,
                arguments: AlbumViewArguments(this.album)),
            child: Column(
              children: <Widget>[
                album.coverart == null
                    ? Icon(Icons.album)
                    : Image(
                        image: api.fetchCoverart(album.coverart),
                      ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(album.title),
                      album.artist == null
                          ? Container()
                          : Text(album.artist.name)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
