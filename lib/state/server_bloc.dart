import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/http.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LOCAL_SERVER = LocalServerConfiguration('Local');

const DEFAULT_STATE =
    ServerState(servers: [LOCAL_SERVER], current: LOCAL_SERVER);

abstract class ServerMsg {
  const ServerMsg();
}

class ServerAddedMsg extends ServerMsg {
  final ServerConfiguration server;

  const ServerAddedMsg(this.server);
}

class ServerSelectedMsg extends ServerMsg {
  final String name;

  const ServerSelectedMsg(this.name);
}

class ServerState {
  final List<ServerConfiguration> servers;
  final ServerConfiguration? current;

  const ServerState({required this.servers, this.current});

  List<ServerConfiguration> available() {
    return servers.where((server) => server != current).toList();
  }
}

abstract class ServerConfiguration {
  final String name;

  const ServerConfiguration(this.name);

  String label();

  Api? getApi();
}

class HttpServerConfiguration extends ServerConfiguration {
  final String ip;
  final int port;
  late HttpApi api;

  HttpServerConfiguration({required this.ip, required this.port, name}) : super(name) {
    this.api = HttpApi(baseUrl: '$ip:$port');
  }

  @override
  String label() {
    return '$ip:$port';
  }

  @override
  Api getApi() {
    return this.api;
  }
}

class LocalServerConfiguration extends ServerConfiguration {
  const LocalServerConfiguration(name) : super(name);

  @override
  String label() {
    return 'local';
  }

  @override
  Api? getApi() {
    return null;
  }
}

class ServerBloc extends Bloc<ServerMsg, ServerState> {
  final SharedPreferences sharedPreferences;

  ServerBloc(this.sharedPreferences) : super(load(sharedPreferences)) {
    on<ServerAddedMsg>((event, emit) {
      var current = state.current;
      if (state.servers.length == 0) {
        current = event.server;
      }
      emit(ServerState(
          current: current, servers: [...state.servers, event.server]));
    });
    on<ServerSelectedMsg>((event, emit) {
      var current = state.servers.firstWhere((server) => server.name == event.name);
      emit(ServerState(current: current, servers: state.servers));
    });
    on<ServerMsg>((event, emit) async {
      await this.persist();
    }, transformer: sequential());
  }

  Future<void> persist() async {
    for (var server in state.servers) {
      await sharedPreferences.setString(
          'servers/${server.name}/name', server.name);
      await sharedPreferences.setString('servers/${server.name}/type',
          server is HttpServerConfiguration ? 'http' : 'local');
      if (server is HttpServerConfiguration) {
        await sharedPreferences.setString(
            'servers/${server.name}/ip', server.ip);
        await sharedPreferences.setInt(
            'servers/${server.name}/port', server.port);
      }
    }
    await sharedPreferences.setString('current', state.current!.name);
    await sharedPreferences.setStringList(
        'servers', state.servers.map((e) => e.name).toList());
  }

  Stream<SocketMessage> events() {
    return this.stream.startWith(state).switchMap<SocketMessage>((state) {
      return state.current?.getApi()?.messages() ?? Stream.empty();
    });
  }

  Api? getApi() {
    return this.state.current?.getApi();
  }
}

ServerState load(SharedPreferences sharedPreferences) {
  if (!sharedPreferences.containsKey('servers')) {
    return ServerState(servers: [], current: null);
  }
  List<ServerConfiguration> servers = [];
  var serverNames = sharedPreferences.getStringList('servers') ?? [];
  for (var name in serverNames) {
    var type = sharedPreferences.getString('servers/$name/type');
    if (type == 'local') {
      servers.add(LocalServerConfiguration(name));
    }
    if (type == 'http') {
      var ip = sharedPreferences.getString('servers/$name/ip')!;
      var port = sharedPreferences.getInt('servers/$name/port')!;
      servers.add(HttpServerConfiguration(ip: ip, port: port, name: name));
    }
  }
  var currentName = sharedPreferences.getString('current');
  var current = servers.firstWhere((server) => server.name == currentName);

  return ServerState(current: current, servers: servers);
}
