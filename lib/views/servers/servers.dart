import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/drawer.dart';

class ServersView extends StatelessWidget {
  static const routeName = '/servers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: RusticDrawer(),
        appBar: AppBar(title: Text('Servers')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var dialog = SimpleDialog(
              title: Text('Add Server'),
              children: <Widget>[AddServer()],
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
}

class AddServer extends StatefulWidget {
  final void Function(ServerConfiguration) onDone;

  AddServer({this.onDone});

  @override
  _AddServerState createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = context.bloc<ServerBloc>();
    return ListView(
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
                      if (widget.onDone != null) {
                        widget.onDone(config);
                      }
                      Navigator.pop(context);
                    })
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ))
      ],
    );
  }
}
