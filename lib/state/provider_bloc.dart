import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/provider.dart';
import 'package:rustic/state/server_bloc.dart';

abstract class ProviderMsg {}

class ToggleProvider extends ProviderMsg {
  final String provider;

  ToggleProvider(this.provider);

  @override
  String toString() {
    return "ToggleProvider { provider: $provider }";
  }
}

class FetchProviders extends ProviderMsg {}

class ProviderList {
  final List<String> providers;
  final List<String> active;

  ProviderList({this.providers, this.active});

  @override
  String toString() {
    return "ProviderList { providers: $providers, active: $active }";
  }
}

class ProviderBloc extends Bloc<ProviderMsg, ProviderList> {
  final ServerBloc serverBloc;

  ProviderBloc({this.serverBloc});

  @override
  ProviderList get initialState =>
      ProviderList(providers: List(), active: List());

  @override
  Stream<ProviderList> mapEventToState(ProviderMsg event) async* {
    if (event is ToggleProvider) {
      if (state.active.contains(event.provider)) {
        yield ProviderList(
            providers: state.providers,
            active: state.active
                .where((element) => element != event.provider)
                .toList());
      } else {
        yield ProviderList(
            providers: state.providers,
            active: [...state.active, event.provider]);
      }
    }
    if (event is FetchProviders) {
      var providers = await serverBloc.getApi().fetchProviders();
      var providerNames = providers
          .where((p) =>
              p.authState.state == AuthStateModel.Authenticated ||
              p.authState.state == AuthStateModel.NoAuthentication)
          .map((p) => p.provider)
          .toList();

      yield ProviderList(active: providerNames, providers: providerNames);
    }
  }
}
