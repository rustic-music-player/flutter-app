import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/ui/albums/album-list.dart';
import 'package:rustic/ui/playlists/playlist-list.dart';
import 'package:rustic/views/search/albums.dart';
import 'package:rustic/views/search/playlists.dart';
import 'package:rustic/views/search/search_bloc.dart';

const MAX_ALBUMS = 4;
const MAX_PLAYLISTS = 5;

class SearchView extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String query;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchResultModel>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Search...'),
                  textInputAction: TextInputAction.search,
                  onChanged: (String query) {
                    this.query = query;
                    context.bloc<SearchBloc>().add(query);
                  }),
            ),
            body: SearchResultView(state, query)));
  }
}

class SearchResultView extends StatelessWidget {
  final SearchResultModel results;
  final String query;

  SearchResultView(this.results, this.query);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[ProviderSelection()];
    addAlbumList(context, widgets);
    addPlaylistList(context, widgets);
    return ListView(
      scrollDirection: Axis.vertical,
      children: widgets,
    );
  }

  void addAlbumList(BuildContext context, List<Widget> widgets) {
    if (results.albums.length > 0) {
      widgets.add(SearchHeader(
          "Albums",
          () => Navigator.pushNamed(context, SearchAlbumView.routeName,
              arguments: SearchAlbumArguments(results.albums, query))));
      widgets.add(AlbumList(
        albums: results.albums.sublist(0, MAX_ALBUMS),
      ));
    }
  }

  void addPlaylistList(BuildContext context, List<Widget> widgets) {
    if (results.playlists.length > 0) {
      widgets.add(SearchHeader(
          "Playlists",
          () => Navigator.pushNamed(context, SearchPlaylistView.routeName,
              arguments: SearchPlaylistArguments(results.playlists, query))));
      widgets.add(PlaylistList(
        playlists: results.playlists.sublist(0, MAX_PLAYLISTS),
      ));
    }
  }
}

class ProviderSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.all(4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ProviderToggle(MdiIcons.googlePlay, Color.fromARGB(255, 255, 87, 34)),
          ProviderToggle(MdiIcons.spotify, Color.fromARGB(255, 29, 185, 84)),
          ProviderToggle(MdiIcons.soundcloud, Color.fromARGB(255, 255, 85, 0)),
          ProviderToggle(MdiIcons.plex, Color.fromARGB(255, 229, 160, 13)),
          ProviderToggle(MdiIcons.youtube, Color.fromARGB(255, 255, 0, 0)),
          ProviderToggle(MdiIcons.folder, Color.fromARGB(255, 96, 125, 139))
        ],
      ),
    );
  }
}

class ProviderToggle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ProviderToggle(
    this.icon,
    this.color, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Ink(
        decoration: ShapeDecoration(shape: CircleBorder(), color: this.color),
        child: IconButton(
          icon: Icon(
            this.icon,
            color: Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class SearchHeader extends StatelessWidget {
  final String title;
  final Function onPress;

  SearchHeader(this.title, this.onPress);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onPressed: onPress,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(this.title)),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}
