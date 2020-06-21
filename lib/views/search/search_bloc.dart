import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/state/provider_bloc.dart';
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
  final Api api;
  final ProviderBloc providerBloc;
  StreamSubscription providerBlocSubscription;
  List<String> providers = List();
  String query;

  SearchBloc({this.api, this.providerBloc}) {
    providerBlocSubscription = providerBloc.listen((state) {
      this.add(ProviderSelectionChanged(state.active));
    });
  }

  @override
  Future<void> close() {
    providerBlocSubscription.cancel();
    return super.close();
  }

  @override
  SearchResultModel get initialState => SearchResultModel(
      artists: List(), albums: List(), playlists: List(), tracks: List());

  @override
  Stream<Transition<SearchEvent, SearchResultModel>> transformEvents(
      Stream<SearchEvent> events, next) {
    return events.debounceTime(Duration(milliseconds: 500)).switchMap(next);
  }

  @override
  Stream<SearchResultModel> mapEventToState(event) async* {
    if (event is SearchQuery) {
      this.query = event.query;
    }
    if (event is ProviderSelectionChanged) {
      this.providers = event.providers;
    }
    if (query == null) {
      return;
    }
    yield await this.api.search(this.query, this.providers);
  }
}
