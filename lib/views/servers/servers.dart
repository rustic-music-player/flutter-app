import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/drawer.dart';

class ServersView extends StatefulWidget {
  static const routeName = '/servers';

  @override
  _ServersViewState createState() => _ServersViewState();
}

class _ServersViewState extends State<ServersView> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = context.bloc<ServerBloc>();
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(title: Text('Servers')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var dialog = SimpleDialog(
              title: Text('Add Server'),
              children: <Widget>[
                TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name')),
                TextFormField(
                    controller: ipController,
                    decoration: const InputDecoration(labelText: 'Ip')),
                TextFormField(
                    controller: portController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: 'Port')),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context)),
                        RaisedButton(
                            child: Text('Add'),
                            onPressed: () {
                              var config = HttpServerConfiguration(
                                  name: nameController.value.text,
                                  ip: ipController.value.text,
                                  port: int.parse(portController.value.text));
                              bloc.add(ServerAddedMsg(config));
                              Navigator.pop(context);
                            })
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ))
              ],
              contentPadding: EdgeInsets.all(16),
            );
            showDialog(context: context, child: dialog);
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<ServerBloc, ServerState>(
          builder: (context, state) => ListView(
              children: state.servers
                  .map((c) => ListTile(
                        title: Text(c.name),
                        subtitle: Text(c.label()),
                      ))
                  .toList()),
        ));
  }

  @override
  void dispose() {
    nameController.dispose();
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }
}
