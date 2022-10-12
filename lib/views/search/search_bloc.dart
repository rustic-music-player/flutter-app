import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/state/provider_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchEvent {}

class SearchQuery extends SearchEvent {
  final String query;

  SearchQuery(this.query);

  @override
  String toString() {
    return "SearchQuery { query: $query }";
  }
}

class ProviderSelectionChanged extends SearchEvent {
  final List<String> providers;

  ProviderSelectionChanged(this.providers);

  @override
  String toString() {
    return "ProviderSelectionChanged { providers: $providers }";
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchResultModel> {
  final ServerBloc serverBloc;
  final ProviderBloc providerBloc;
  late StreamSubscription providerBlocSubscription;
  List<String> providers = [];
  String? query;

  SearchBloc({required this.serverBloc, required this.providerBloc}): super(SearchResultModel(
      artists: [], albums: [], playlists: [], tracks: [])) {
    providerBlocSubscription = providerBloc.stream.listen((state) {
      this.add(ProviderSelectionChanged(state.active));
    });
    on<SearchEvent>((event, emit) async {
      if (event is SearchQuery) {
        this.query = event.query;
      }
      if (event is ProviderSelectionChanged) {
        this.providers = event.providers;
      }
      if (query == null) {
        return;
      }
      var resultModel = await this.serverBloc.getApi()?.search(this.query!, this.providers);
      if (resultModel != null) {
        emit(resultModel);
      }
    }, transformer: debounce(Duration(milliseconds: 500)));
  }

  @override
  Future<void> close() {
    providerBlocSubscription.cancel();
    return super.close();
  }
}

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}
