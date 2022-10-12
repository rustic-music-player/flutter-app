import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/ui/albums/album-list.dart';
import 'package:rustic/views/search/search_bloc.dart';

class SearchAlbumArguments {
  final List<AlbumModel> albums;
  final String query;

  SearchAlbumArguments(this.albums, this.query);
}

class SearchAlbumView extends StatelessWidget {
  static const routeName = '/search/albums';

  @override
  Widget build(BuildContext context) {
    SearchAlbumArguments args = ModalRoute.of(context)!.settings.arguments! as SearchAlbumArguments;
    return BlocBuilder<SearchBloc, SearchResultModel>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text(args.query),
            ),
            body:
                ListView(children: <Widget>[AlbumList(albums: args.albums)])));
  }
}
