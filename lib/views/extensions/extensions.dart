import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/extension.dart';
import 'package:rustic/state/extensions_bloc.dart';
import 'package:rustic/ui/drawer.dart';
import 'package:rustic/ui/player.dart';
import 'package:rustic/ui/refreshable-list.dart';

class ExtensionsView extends StatelessWidget {
  static const routeName = '/extensions';

  const ExtensionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(title: Text('Extensions')),
        body: Column(
          children: [
            Expanded(
              child: RefreshableList<ExtensionsBloc, ExtensionModel>(
                builder: (context, extension) {
                  ExtensionsBloc bloc = context.read();

                  return ListTile(
                    title: Text(extension.name),
                    subtitle: Text(extension.version),
                    trailing: Switch(value: extension.enabled, onChanged: (enabled) => bloc.add(ToggleExtension(extension.id))),
                  );
                },
              ),
            ),
            RusticPlayerBar()
          ],
        ));
  }
}
