import 'package:bloc/bloc.dart';
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

  ProviderList({required this.providers, required this.active});

  @override
  String toString() {
    return "ProviderList { providers: $providers, active: $active }";
  }
}

class ProviderBloc extends Bloc<ProviderMsg, ProviderList> {
  final ServerBloc serverBloc;

  ProviderBloc({required this.serverBloc}) : super(ProviderList(providers: [], active: [])) {
    on<ToggleProvider>((event, emit) {
      if (state.active.contains(event.provider)) {
        emit(ProviderList(
            providers: state.providers,
            active: state.active
                .where((element) => element != event.provider)
                .toList()));
      } else {
        emit(ProviderList(
            providers: state.providers,
            active: [...state.active, event.provider]));
      }
    });
    on<FetchProviders>((event, emit) async {
      var providers = await serverBloc.getApi()!.fetchProviders();
      var providerNames = providers
          .where((p) =>
      p.authState.state == AuthStateModel.Authenticated ||
          p.authState.state == AuthStateModel.NoAuthentication)
          .map((p) => p.provider)
          .toList();

      emit(ProviderList(active: providerNames, providers: providerNames));
    });
  }
}
