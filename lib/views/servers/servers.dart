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
          onPressed: () => _addServer(context),
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<ServerBloc, ServerState>(
          builder: (context, state) => ListView(
              children: state.servers
                  .map((server) => ListTile(
                        title: Text(server.name),
                        subtitle: Text(server.label()),
                        onTap: () => _editServer(context, server),
                      ))
                  .toList()),
        ));
  }

  void _addServer(BuildContext context) async {
    var dialog = SimpleDialog(
      title: Text('Add Server'),
      children: [ServerSettings()],
      contentPadding: EdgeInsets.all(16),
    );
    ServerConfiguration? result = await showDialog(context: context, builder: (context) => dialog);
    if (result == null) {
      return;
    }
    ServerBloc bloc = context.read();
    bloc.add(ServerAddedMsg(result));
  }

  void _editServer(BuildContext context, ServerConfiguration config) async {
    var dialog = SimpleDialog(
      title: Text('Edit Server'),
      children: [ServerSettings(config: config)],
      contentPadding: EdgeInsets.all(16),
    );
    ServerConfiguration? result = await showDialog(context: context, builder: (context) => dialog);
    if (result == null) {
      return;
    }
    ServerBloc bloc = context.read();
    bloc.add(ServerEditedMsg(config, result));
  }
}

class ServerSettings extends StatefulWidget {
  final void Function(ServerConfiguration)? onDone;
  final ServerConfiguration? config;

  ServerSettings({this.onDone, this.config});

  @override
  _ServerSettingsState createState() => _ServerSettingsState();
}

class _ServerSettingsState extends State<ServerSettings> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.config == null) {
      return;
    }
    HttpServerConfiguration config = widget.config! as HttpServerConfiguration; // TODO: this will break once we have local playback
    this.nameController.text = config.name;
    this.ipController.text = config.ip;
    this.portController.text = config.port.toString();
  }

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.read();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(labelText: 'Port')),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: <Widget>[
                TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context)),
                ElevatedButton(
                    child: Text(widget.config == null ? 'Add' : 'Save'),
                    onPressed: () {
                      var config = HttpServerConfiguration(
                          name: nameController.value.text,
                          ip: ipController.value.text,
                          port: int.parse(portController.value.text));
                      if (widget.onDone != null) {
                        widget.onDone!(config);
                      }
                      Navigator.pop(context, config);
                    })
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ))
      ],
    );
  }
}
