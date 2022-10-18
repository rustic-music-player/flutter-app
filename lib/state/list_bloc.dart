import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/socket_msg.dart';

import 'server_bloc.dart';

class ListState<T> {
  final List<T> items;
  final bool loading;

  ListState({required this.items, this.loading = false});

  factory ListState.empty() {
    return ListState(items: []);
  }
}

abstract class ListEvent<T> {}

class FetchList<T> extends ListEvent<T> {}

class SocketEvent<T> extends ListEvent<T> {
  final SocketMessage message;

  SocketEvent(this.message);
}

abstract class ListBloc<T> extends Bloc<ListEvent<T>, ListState<T>> {
  final ServerBloc serverBloc;
  final List<String> socketRefreshTypes;
  late StreamSubscription? _socketSubscription;

  ListBloc(this.serverBloc, {List<String>? socketRefreshTypes})
      : this.socketRefreshTypes = socketRefreshTypes ?? [],
        super(ListState.empty()) {
    if (this.socketRefreshTypes.isNotEmpty) {
      _subscribeToSocket();
    }
    on<SocketEvent<T>>(_handleSocketMessage);
    on<FetchList<T>>(_refreshList);
  }

  @override
  Future<void> close() async {
    await super.close();
    await _socketSubscription?.cancel();
  }

  Future<List<T>> load(Api api);

  _subscribeToSocket() {
    this._socketSubscription = serverBloc.events().listen((msg) {
      this.add(SocketEvent(msg));
    });
  }

  _handleSocketMessage(SocketEvent<T> event, Emitter<ListState<T>> emit) {
    log("_handleSocketMessage $event");
    if (socketRefreshTypes.contains(event.message.type)) {
      this.add(FetchList());
    }
  }

  _refreshList(FetchList<T> event, Emitter<ListState<T>> emit) async {
    log("_refreshList $event");
    emit(ListState(items: state.items, loading: true));
    Api api = serverBloc.getApi()!;
    var items = await load(api);

    emit(ListState(items: items));
  }

  Api get api {
    return serverBloc.getApi()!;
  }
}
