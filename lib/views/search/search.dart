import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/views/search/search_bloc.dart';

class SearchView extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchViewState createState() {
    return new _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  final searchStreamController = new StreamController<String>();
  final searchController = new TextEditingController();

  @override
  void dispose() {
    searchStreamController.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.bloc<SearchBloc>();

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Search...'),
            textInputAction: TextInputAction.search,
            onChanged: (String query) => search(query, bloc),
          ),
        ),
        body: BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, SearchResultModel state) {
              return SearchResultView(results: state);
            }));
  }

  void search(String query, SearchBloc bloc) {
    searchStreamController.add(query);
    bloc.add(query);
  }
}

class SearchResultView extends StatelessWidget {
  final SearchResultModel results;

  SearchResultView({this.results});

  @override
  Widget build(BuildContext context) {
    return SearchAlbumView(albums: results.albums);
  }
}

class SearchAlbumView extends StatelessWidget {
  final List<AlbumModel> albums;

  SearchAlbumView({this.albums});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: this
          .albums
          .map((album) => SearchAlbumEntry(
                album: album,
              ))
          .toList(),
    );
  }
}

class SearchAlbumEntry extends StatelessWidget {
  final AlbumModel album;

  SearchAlbumEntry({this.album});

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            album.coverart == null
                ? Icon(Icons.album)
                : Image(image: api.fetchCoverart(album.coverart)),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[Text(album.title), Text(album.artist.name)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
