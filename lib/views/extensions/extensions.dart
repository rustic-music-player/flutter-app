import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/extension.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';

class ExtensionsView extends StatefulWidget {
  static const routeName = '/extensions';

  @override
  _ExtensionsViewState createState() => _ExtensionsViewState();
}

class _ExtensionsViewState extends State<ExtensionsView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<ExtensionModel> extensions = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        var api = state.current!.getApi()!;

        return Scaffold(
          drawer: RusticDrawer(),
          appBar: AppBar(title: Text('Extensions'), actions: [
            IconButton(
                onPressed: () => _refreshController.requestRefresh(),
                icon: Icon(Icons.refresh))
          ]),
          body: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    header: MaterialClassicHeader(),
                    onLoading: () => this
                        .load(api)
                        .then((value) => _refreshController.loadComplete()),
                    onRefresh: () => this
                        .load(api)
                        .then((value) => _refreshController.refreshCompleted()),
                    child: ExtensionList(
                      extensions: this.extensions,
                      api: api,
                    )),
              ),
              RusticPlayerBar()
            ],
          ));
      },
    );
  }

  Future<void> load(Api api) async {
    var extensions = await api.fetchExtensions();
    setState(() {
      this.extensions = extensions;
    });
  }
}

class ExtensionList extends StatelessWidget {
  final List<ExtensionModel> extensions;
  final Api api;

  const ExtensionList({required this.extensions, required this.api, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: extensions.length,
      itemBuilder: (context, i) {
        var extension = extensions[i];

        return ListTile(
          title: Text(extension.name),
          subtitle: Text(extension.version),
          trailing: Switch(value: extension.enabled, onChanged: (enabled) => enabled ? api.enableExtension(extension.id) : api.disableExtension(extension.id)),
        );
      },
    );
  }
}
