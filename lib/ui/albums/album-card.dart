import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/views/library/album.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;

  AlbumCard(this.album);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.bloc();
    return FractionallySizedBox(
        widthFactor: .5,
        child: Card(
          child: FlatButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Navigator.pushNamed(context, AlbumView.routeName,
                arguments: AlbumViewArguments(this.album)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 1,
                    child: album.coverart == null
                        ? Container(
                            color: Colors.white10,
                            child: Icon(
                              Icons.album,
                              size: 96,
                            ))
                        : Image(
                            image: bloc.getApi().fetchCoverart(album.coverart),
                          )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(album.title),
                      Text(album.artist?.name ?? '')
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
