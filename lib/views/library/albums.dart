import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/albums/album-list.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/search-btn.dart';

class AlbumsView extends StatefulWidget {
  static const routeName = '/albums';

  @override
  _AlbumsViewState createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<AlbumModel> albums = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) => Scaffold(
          drawer: RusticDrawer(),
          appBar:
              AppBar(title: Text('Albums'), actions: <Widget>[SearchButton()]),
          body: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  header: MaterialClassicHeader(),
                  onLoading: () => this
                      .load(state.current!.getApi()!)
                      .then((value) => _refreshController.loadComplete()),
                  onRefresh: () => this
                      .load(state.current!.getApi()!)
                      .then((value) => _refreshController.refreshCompleted()),
                  child: ListView(children: <Widget>[
                    AlbumList(
                      albums: this.albums,
                    )
                  ]),
                ),
              ),
              RusticPlayerBar()
            ],
          )),
    );
  }

  Future<void> load(Api api) async {
    var albums = await api.fetchAlbums();
    setState(() {
      this.albums = albums;
    });
  }
}
