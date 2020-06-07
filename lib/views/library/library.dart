import 'package:flutter/material.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/views/library/album.dart';
import 'package:rustic/views/library/artist.dart';
import 'package:rustic/views/library/track.dart';

class LibraryView extends StatefulWidget {
  final Api api;

  LibraryView({this.api});

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
          appBar: AppBar(
            title: Text('Rustic - Library'),
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.of(context).pushNamed('/search'),
                tooltip: 'Search',
              )
            ],
          ),
          body: TabBarView(children: [
            AlbumListView(
              api: widget.api,
            ),
            ArtistListView(
              api: widget.api,
            ),
            TrackListView(
              api: widget.api,
            ),
          ]),
        ));
  }
}
