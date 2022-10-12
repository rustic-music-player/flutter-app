import 'dart:math';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/menu.dart';
import 'package:rustic/ui/provider-selection.dart';
import 'package:rustic/views/library/album.dart';

import '../coverart.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;

  AlbumCard(this.album);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.read();
    var api = bloc.getApi();
    var provider = providerMap[album.provider];
    return ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: 100, maxWidth: min(250, MediaQuery.of(context).size.width / 2)),
        child: FutureBuilder(
          future: _getImagePalette(api!),
          builder: (context, AsyncSnapshot<PaletteGenerator> snapshot) => Card(
            color: snapshot.data?.vibrantColor?.color,
            child: MenuContainer(
              onTap: () => Navigator.pushNamed(context, AlbumView.routeName,
                  arguments: AlbumViewArguments(this.album)),
              items: [
                MenuItem('Queue Album',
                    icon: Icons.queue, onSelect: () => api.queueAlbum(album.cursor)),
                MenuItem('Add to Playlist', icon: Icons.playlist_add),
                (album.inLibrary ?? false)
                    ? MenuItem('Remove from Library',
                        icon: Icons.close, onSelect: () => api.removeAlbumFromLibrary(album))
                    : MenuItem('Add to Library',
                        icon: Icons.add, onSelect: () => api.addAlbumToLibrary(album))
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: [
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
                                child: Coverart(album: album),
                              )),
                    (album.explicit ?? false)
                        ? Container(
                            margin: const EdgeInsets.only(left: 8),
                            color: Colors.red,
                            padding: const EdgeInsets.all(4),
                            child: const Text('E', style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                  ]),
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
                                  maxLines: 1, style: TextStyle(color: Colors.white70))
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

  Future<PaletteGenerator>? _getImagePalette(Api api) {
    if (album.coverart == null) {
      return null;
    }
    var coverart = api.fetchCoverart(this.album.coverart!);
    if (coverart == null) {
      return null;
    }

    return PaletteGenerator.fromImageProvider(coverart);
  }
}
