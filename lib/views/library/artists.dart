import 'package:flutter/material.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/state/library/artist_library_bloc.dart';
import 'package:rustic/ui/coverart.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/refreshable-list.dart';
import 'package:rustic/ui/search-btn.dart';

class ArtistsView extends StatelessWidget {
  static const routeName = 'artists';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(
          title: Text('Artists'),
          actions: <Widget>[SearchButton()],
        ),
        body: Column(children: [
          Expanded(
              child: RefreshableList<ArtistLibraryBloc, ArtistModel>(
                builder: (context, artist) => ArtistListItem(artist),
              )),
          RusticPlayerBar()
        ]));
  }
}

class ArtistListItem extends StatelessWidget {
  final ArtistModel artist;

  ArtistListItem(this.artist);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name),
      leading: CircleAvatar(
          child: artist.image == null
              ? Icon(Icons.person)
              : Coverart(artist: artist)),
    );
  }
}
