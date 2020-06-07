import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/search.dart';

class SearchView extends StatefulWidget {
  final Api api;

  SearchView({this.api});

  @override
  _SearchViewState createState() {
    return new _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  Stream<SearchResultModel> searchResultStream;
  final searchStreamController = new StreamController<String>();
  final searchController = new TextEditingController();

  _SearchViewState() {
    searchResultStream = searchStreamController.stream
        .asyncMap((query) => widget.api.search(query));
  }

  @override
  void dispose() {
    searchStreamController.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Search...'),
            textInputAction: TextInputAction.search,
            onChanged: search,
          ),
        ),
        body: StreamBuilder<SearchResultModel>(
            stream: searchResultStream,
            builder: (BuildContext context,
                AsyncSnapshot<SearchResultModel> snapshot) {
              if (snapshot.hasData) {
                return SearchResultView(
                    results: snapshot.data, api: widget.api);
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            }));
  }

  void search(String value) {
    searchStreamController.add(value);
  }
}

class SearchResultView extends StatelessWidget {
  final SearchResultModel results;
  final Api api;

  SearchResultView({this.results, this.api});

  @override
  Widget build(BuildContext context) {
    return SearchAlbumView(
      albums: results.albums,
      api: api,
    );
  }
}

class SearchAlbumView extends StatelessWidget {
  final List<AlbumModel> albums;
  final Api api;

  SearchAlbumView({this.albums, this.api});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: this
          .albums
          .map((album) => SearchAlbumEntry(
                album: album,
                api: api,
              ))
          .toList(),
    );
  }
}

class SearchAlbumEntry extends StatelessWidget {
  final AlbumModel album;
  final Api api;

  SearchAlbumEntry({this.album, this.api});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            album.coverart == null
                ? Icon(Icons.album)
                : api.fetchAlbumCoverart(album),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(album.title),
                  Text(album.artist.name)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
