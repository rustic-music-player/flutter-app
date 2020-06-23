import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/albums/album-list.dart';

class AlbumListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(builder: (context, state) {
      var api = state.current.getApi();
      return FutureBuilder<List<AlbumModel>>(
          future: api.fetchAlbums(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children: <Widget>[AlbumList(albums: snapshot.data)]);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          });
    });
  }
}
