import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/views/album/album.dart';
import 'package:rustic/views/search/search_bloc.dart';

class SearchView extends StatelessWidget {
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchResultModel>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: 'Search...'),
                textInputAction: TextInputAction.search,
                onChanged: (String query) =>
                    context.bloc<SearchBloc>().add(query),
              ),
            ),
            body: SearchResultView(results: state)));
  }
}

class SearchResultView extends StatelessWidget {
  final SearchResultModel results;

  SearchResultView({this.results});

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    addAlbumList(widgets);
    return ListView(
      scrollDirection: Axis.vertical,
      children: widgets,
    );
  }

  void addAlbumList(List<Widget> widgets) {
    if (results.albums.length > 0) {
      widgets.add(SearchHeader("Albums"));
      widgets.add(SearchAlbumView(
        albums: results.albums,
      ));
    }
  }
}

class SearchHeader extends StatelessWidget {
  final String title;

  SearchHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(this.title)),
          RaisedButton(
            child: Text("Expand"),
          )
        ],
      ),
    );
  }
}

class SearchAlbumView extends StatelessWidget {
  final List<AlbumModel> albums;

  SearchAlbumView({this.albums});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: this
          .albums
          .sublist(0, 4)
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
    return FractionallySizedBox(
        widthFactor: .5,
        child: Card(
          child: FlatButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Navigator.pushNamed(context, AlbumView.routeName,
                arguments: AlbumViewArguments(this.album)),
            child: Column(
              children: <Widget>[
                album.coverart == null
                    ? Icon(Icons.album)
                    : Image(
                        image: api.fetchCoverart(album.coverart),
                      ),
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
        ));
  }
}
