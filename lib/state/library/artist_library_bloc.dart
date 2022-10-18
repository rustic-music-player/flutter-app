import 'dart:async';

import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/state/list_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

const _artistAddedMsg = 'ARTIST_ADDED';

class ArtistLibraryBloc extends ListBloc<ArtistModel> {
  ArtistLibraryBloc(ServerBloc serverBloc)
      : super(serverBloc, socketRefreshTypes: [_artistAddedMsg]);

  @override
  Future<List<ArtistModel>> load(Api api) {
    return api.fetchArtists();
  }
}
