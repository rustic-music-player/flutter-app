import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RusticDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
        ],
      ),
    );
  }
}
