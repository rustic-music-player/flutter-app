import 'package:flutter/material.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/artist.dart';

class ArtistListView extends StatelessWidget {
  final Api api;

  ArtistListView({this.api});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistModel>>(
      future: api.fetchArtists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ArtistList(
            artists: snapshot.data,
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

class ArtistList extends StatelessWidget {
  final List<ArtistModel> artists;
  final Api api;

  ArtistList({this.artists, this.api});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .artists
          .map<Widget>((a) => ArtistListItem(
                api: api,
                artist: a,
              ))
          .toList(),
    );
  }
}

class ArtistListItem extends StatelessWidget {
  final ArtistModel artist;
  final Api api;

  ArtistListItem({this.artist, this.api});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name),
      leading: CircleAvatar(child: api.fetchArtistImage(artist)),
    );
  }
}
