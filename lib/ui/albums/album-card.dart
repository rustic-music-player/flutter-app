import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/provider-selection.dart';
import 'package:rustic/views/library/album.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;

  AlbumCard(this.album);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.bloc();
    var provider = providerMap[album.provider];
    return FractionallySizedBox(
        widthFactor: .5,
        child: FutureBuilder(
          future: PaletteGenerator.fromImageProvider(
              bloc.getApi().fetchCoverart(this.album.coverart)),
          builder: (context, AsyncSnapshot<PaletteGenerator> snapshot) => Card(
            color: snapshot.data?.vibrantColor?.color,
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
                          : Hero(
                              tag: album.cursor,
                              child: Image(
                                image:
                                    bloc.getApi().fetchCoverart(album.coverart),
                              ),
                            )),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 64,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(album.title, maxLines: 2),
                              Text(album.artist?.name ?? '',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white70))
                            ],
                          ),
                        ),
                        Icon(
                          provider?.icon,
                          color: provider?.color,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
