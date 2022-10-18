import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/coverart.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/search-btn.dart';

class ArtistsView extends StatelessWidget {
  static const routeName = 'artists';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) => FutureBuilder(
          future: state.current?.getApi()?.fetchArtists(),
          builder: (context, AsyncSnapshot<List<ArtistModel>> snapshot) => Scaffold(
              drawer: RusticDrawer(),
              appBar: AppBar(
                  title: Text('Artists'),
                  actions: <Widget>[SearchButton()],
                  bottom: snapshot.hasData
                      ? null
                      : PreferredSize(
                          child: LinearProgressIndicator(),
                          preferredSize: Size.fromHeight(4))),
              body: Column(children: <Widget>[
                Expanded(
                    child: ArtistList(
                  artists: snapshot.data ?? [],
                )),
                RusticPlayerBar()
              ]))),
    );
  }
}

class ArtistList extends StatelessWidget {
  final List<ArtistModel> artists;

  ArtistList({required this.artists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, i) => ArtistListItem(artist: artists[i]),
    );
  }
}

class ArtistListItem extends StatelessWidget {
  final ArtistModel artist;

  ArtistListItem({required this.artist});

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
