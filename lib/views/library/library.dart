import 'package:flutter/material.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/search-btn.dart';
import 'package:rustic/views/library/album.dart';
import 'package:rustic/views/library/artist.dart';
import 'package:rustic/views/library/track.dart';

class LibraryView extends StatefulWidget {
  @override
  LibraryViewState createState() {
    return new LibraryViewState();
  }
}

class LibraryViewState extends State<LibraryView> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: RusticDrawer(),
          appBar: AppBar(
            title: Text('Library'),
            bottom: TabBar(tabs: [
              Tab(
                text: 'Albums',
              ),
              Tab(
                text: 'Artists',
              ),
              Tab(
                text: 'Tracks',
              )
            ]),
            actions: <Widget>[SearchButton()],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: TabBarView(children: [
                AlbumListView(),
                ArtistListView(),
                TrackListView(),
              ])),
              RusticPlayerBar()
            ],
          ),
        ));
  }
}
