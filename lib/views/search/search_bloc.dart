import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<String, SearchResultModel> {
  final Api api;

  SearchBloc({this.api});

  @override
  SearchResultModel get initialState => SearchResultModel(
      artists: List(), albums: List(), playlists: List(), tracks: List());

  @override
  Stream<Transition<String, SearchResultModel>> transformEvents(
      Stream<String> events, next) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), next);
  }

  @override
  Stream<SearchResultModel> mapEventToState(event) async* {
    yield await this.api.search(event);
  }
}
