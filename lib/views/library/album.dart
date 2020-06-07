import 'package:flutter/material.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';

class AlbumListView extends StatelessWidget {
  final Api api;

  AlbumListView({this.api});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AlbumModel>>(
      future: api.fetchAlbums(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlbumList(
            albums: snapshot.data,
            api: api,
          );
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
  final Api api;

  AlbumList({this.albums, this.api});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .albums
          .map<Widget>((a) => AlbumListItem(
        api: api,
        album: a,
      ))
          .toList(),
    );
  }
}

class AlbumListItem extends StatelessWidget {
  final AlbumModel album;
  final Api api;

  AlbumListItem({this.album, this.api});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(album.title),
      leading: CircleAvatar(child: api.fetchAlbumCoverart(album)),
    );
  }
}