import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';

const queueUpdatedMsg = 'QUEUE_UPDATED';

class FetchQueue {}

class QueueBloc extends Bloc<dynamic, List<TrackModel>> {
  final Api api;
  StreamSubscription socketSubscription;

  QueueBloc({this.api}) {
    socketSubscription = api.messages().listen((event) {
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
      yield await api.getQueue();
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
