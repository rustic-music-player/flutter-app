import 'dart:async';

import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/state/list_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

const _playlistAddedMsg = 'PLAYLIST_ADDED';

class PlaylistLibraryBloc extends ListBloc<PlaylistModel> {
  PlaylistLibraryBloc(ServerBloc serverBloc)
      : super(serverBloc, socketRefreshTypes: [_playlistAddedMsg]);

  @override
  Future<List<PlaylistModel>> load(Api api) {
    return api.fetchPlaylists();
  }
}
