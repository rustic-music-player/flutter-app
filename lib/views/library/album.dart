import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';

class AlbumListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return FutureBuilder<List<AlbumModel>>(
      future: api.fetchAlbums(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlbumList(albums: snapshot.data);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class AlbumList extends StatelessWidget {
  final List<AlbumModel> albums;

  AlbumList({this.albums});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .albums
          .map<Widget>((a) => AlbumListItem(
                album: a,
              ))
          .toList(),
    );
  }
}

class AlbumListItem extends StatelessWidget {
  final AlbumModel album;

  AlbumListItem({this.album});

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return ListTile(
      title: Text(album.title),
      leading: CircleAvatar(child: api.fetchAlbumCoverart(album)),
    );
  }
}
