import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/extension.dart';
import 'package:rustic/state/list_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

class ToggleExtension extends ListEvent<ExtensionModel> {
  final String id;
  
  ToggleExtension(this.id);
}

class ExtensionsBloc extends ListBloc<ExtensionModel> {
  ExtensionsBloc(ServerBloc serverBloc)
      : super(serverBloc) {
    on<ToggleExtension>(_handleToggleExtension);
  }

  @override
  Future<List<ExtensionModel>> load(Api api) {
    return api.fetchExtensions();
  }

  _handleToggleExtension(ToggleExtension event, Emitter<ListState<ExtensionModel>> emit) async {
    ExtensionModel extension = state.items.firstWhere((element) => element.id == event.id);
    await _toggleExtension(extension);

    var index = state.items.indexOf(extension);
    var extensions = [...state.items];
    extensions[index] = ExtensionModel(
        name: extension.name,
        id: extension.id,
        enabled: !extension.enabled,
        version: extension.version,
        controls: extension.controls
    );

    emit(ListState(items: extensions));
  }

  Future<void> _toggleExtension(ExtensionModel extension) async {
    if (extension.enabled) {
      await api.disableExtension(extension.id);
    }else {
      await api.enableExtension(extension.id);
    }
  }
}
