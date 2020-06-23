import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/views/library/albums.dart';
import 'package:rustic/views/library/artists.dart';
import 'package:rustic/views/library/tracks.dart';
import 'package:rustic/views/library/playlists.dart';
import 'package:rustic/views/servers/servers.dart';

class RusticDrawer extends StatefulWidget {
  @override
  _RusticDrawerState createState() => _RusticDrawerState();
}

class _RusticDrawerState extends State<RusticDrawer> {
  bool showList = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<ServerBloc, ServerState>(
        builder: (context, state) => ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  child: Text(state.current.name[0].toUpperCase(),
                      style: TextStyle(fontSize: 40))),
              otherAccountsPictures: state
                  .available()
                  .map((s) => GestureDetector(
                        child:
                            CircleAvatar(child: Text(s.name[0].toUpperCase())),
                        onTap: () => context
                            .bloc<ServerBloc>()
                            .add(ServerSelectedMsg(s.name)),
                      ))
                  .toList(),
              accountName: Text(state.current.name),
              accountEmail: Text(state.current.label()),
              onDetailsPressed: () => setState(() {
                this.showList = !this.showList;
              }),
            ),
            ServerList(showList, state.servers),
            RusticNavigation()
          ],
        ),
      ),
    );
  }
}

class ServerList extends StatelessWidget {
  final bool showList;
  final List<ServerConfiguration> servers;

  ServerList(this.showList, this.servers);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.bloc();
    if (!showList) {
      return Container();
    }
    return Column(children: <Widget>[
      ...servers
          .map((s) => ListTile(
                title: Text(s.name),
                subtitle: Text(s.label()),
                onTap: () => bloc.add(ServerSelectedMsg(s.name)),
                dense: true,
              ))
          .toList(),
      ListTile(
          title: Text('Manage Servers'),
          trailing: Icon(Icons.edit),
          onTap: () =>
              Navigator.popAndPushNamed(context, ServersView.routeName),
          dense: true),
      Divider()
    ]);
  }
}

class RusticNavigationItem extends StatelessWidget {
  final String title;
  final String routeName;
  final bool dense;
  final IconData icon;

  const RusticNavigationItem(this.title, this.routeName,
      {this.dense = false, this.icon});

  @override
  Widget build(BuildContext context) {
    bool current = ModalRoute.of(context).settings.name == this.routeName;
    return Container(
      child: ListTile(
        title: Text(this.title),
        leading: this.icon == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(this.icon),
              ),
        onTap: () => Navigator.popAndPushNamed(context, this.routeName),
        dense: this.dense,
      ),
      color: current ? Colors.deepOrangeAccent.withAlpha(64) : null,
    );
  }
}

class RusticNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Text('Library',
            style:
                TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
      ),
      RusticNavigationItem('Albums', AlbumsView.routeName, icon: Icons.album),
      RusticNavigationItem('Artists', ArtistsView.routeName,
          icon: Icons.person),
      RusticNavigationItem('Tracks', TracksView.routeName,
          icon: Icons.music_note),
      RusticNavigationItem('Playlists', PlaylistsView.routeName,
          icon: Icons.playlist_play),
      Divider(),
      RusticNavigationItem('Providers', '/providers', dense: true),
      RusticNavigationItem('Extensions', '/extensions', dense: true),
    ]);
  }
}
