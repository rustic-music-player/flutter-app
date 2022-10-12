import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/ui/playlists/playlist-list.dart';
import 'package:rustic/views/search/search_bloc.dart';

class SearchPlaylistArguments {
  final List<PlaylistModel> playlists;
  final String query;

  SearchPlaylistArguments(this.playlists, this.query);
}

class SearchPlaylistView extends StatelessWidget {
  static const routeName = '/search/playlists';

  @override
  Widget build(BuildContext context) {
    SearchPlaylistArguments args = ModalRoute.of(context)!.settings.arguments! as SearchPlaylistArguments;
    return BlocBuilder<SearchBloc, SearchResultModel>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text(args.query),
            ),
            body: ListView(
                children: <Widget>[PlaylistList(playlists: args.playlists)])));
  }
}
