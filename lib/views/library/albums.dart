import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/albums/album-list.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/search-btn.dart';

class AlbumsView extends StatelessWidget {
  static const routeName = '/albums';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) => FutureBuilder(
          future: state.current.getApi().fetchAlbums(),
          builder: (context, snapshot) => Scaffold(
              drawer: RusticDrawer(),
              appBar: AppBar(
                  title: Text('Albums'),
                  actions: <Widget>[SearchButton()],
                  bottom: snapshot.hasData
                      ? null
                      : PreferredSize(
                          child: LinearProgressIndicator(),
                          preferredSize: Size.fromHeight(4))),
              body: Column(children: <Widget>[
                Expanded(
                    child: ListView(children: <Widget>[
                  AlbumList(
                    albums: snapshot.data ?? [],
                  )
                ])),
                RusticPlayerBar()
              ]))),
    );
  }
}
