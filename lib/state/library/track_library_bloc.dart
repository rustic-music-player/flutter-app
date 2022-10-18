import 'dart:async';

import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/list_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

const _trackAddedMsg = 'TRACK_ADDED';

class TrackLibraryBloc extends ListBloc<TrackModel> {
  TrackLibraryBloc(ServerBloc serverBloc)
      : super(serverBloc, socketRefreshTypes: [_trackAddedMsg]);

  @override
  Future<List<TrackModel>> load(Api api) {
    return api.fetchTracks();
  }
}
