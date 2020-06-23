import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';

const queueUpdatedMsg = 'QUEUE_UPDATED';

class FetchQueue {}

class QueueBloc extends Bloc<dynamic, List<TrackModel>> {
  final ServerBloc serverBloc;
  StreamSubscription socketSubscription;

  QueueBloc({this.serverBloc}) {
    socketSubscription = serverBloc.events().listen((event) {
      this.add(event);
    });
  }

  @override
  Future<void> close() {
    socketSubscription.cancel();
    return super.close();
  }

  @override
  List<TrackModel> get initialState => [];

  @override
  Stream<List<TrackModel>> mapEventToState(dynamic event) async* {
    if (event is SocketMessage) {
      yield handleSocketMessage(event);
    } else {
      yield await serverBloc.getApi().getQueue();
    }
  }

  List<TrackModel> handleSocketMessage(SocketMessage event) {
    switch (event.type) {
      case queueUpdatedMsg:
        return event.payload
            .map<TrackModel>((t) => TrackModel.fromJson(t))
            .toList();
    }
    return state;
  }
}
