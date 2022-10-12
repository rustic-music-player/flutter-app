import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';

const queueUpdatedMsg = 'QUEUE_UPDATED';

class FetchQueue {}

class QueueBloc extends Bloc<dynamic, List<TrackModel>> {
  final ServerBloc serverBloc;
  late StreamSubscription socketSubscription;

  QueueBloc({required this.serverBloc}): super([]) {
    socketSubscription = serverBloc.events().listen((event) {
      this.add(event);
    });
    on((event, emit) async {
      if (event is SocketMessage) {
        emit(handleSocketMessage(event));
      }else {
        emit(await serverBloc.getApi()!.getQueue());
      }
    }, transformer: sequential());
  }

  @override
  Future<void> close() {
    socketSubscription.cancel();
    return super.close();
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
