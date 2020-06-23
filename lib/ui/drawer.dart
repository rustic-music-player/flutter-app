import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
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
              ))
          .toList(),
      ListTile(
          title: Text('Manage Servers'),
          onTap: () =>
              Navigator.popAndPushNamed(context, ServersView.routeName)),
      Divider()
    ]);
  }
}

class RusticNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        title: Text('Library'),
        onTap: () {
          Navigator.popAndPushNamed(context, '/');
        },
      ),
      ListTile(
          title: Text('Playlists'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/playlists');
          }),
      ListTile(
          title: Text('Providers'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/providers');
          }),
      ListTile(
          title: Text('Extensions'),
          onTap: () {
            Navigator.popAndPushNamed(context, '/extensions');
          })
    ]);
  }
}
