import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/artist.dart';

class ArtistListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return FutureBuilder<List<ArtistModel>>(
      future: api.fetchArtists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ArtistList(
            artists: snapshot.data,
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

  ArtistList({this.artists});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this
          .artists
          .map<Widget>((a) => ArtistListItem(
                artist: a,
              ))
          .toList(),
    );
  }
}

class ArtistListItem extends StatelessWidget {
  final ArtistModel artist;

  ArtistListItem({this.artist});

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return ListTile(
      title: Text(artist.name),
      leading: CircleAvatar(
          child: artist.image == null
              ? Icon(Icons.person)
              : Image(image: api.fetchCoverart(artist.image))),
    );
  }
}
