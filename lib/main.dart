import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/open_result.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/bloc_logger.dart';
import 'package:rustic/notifications.dart';
import 'package:rustic/state/media_bloc.dart';
import 'package:rustic/state/provider_bloc.dart';
import 'package:rustic/state/queue_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/state/share_url_bloc.dart';
import 'package:rustic/views/library/album.dart';
import 'package:rustic/views/library/albums.dart';
import 'package:rustic/views/library/artists.dart';
import 'package:rustic/views/library/playlist.dart';
import 'package:rustic/views/library/playlists.dart';
import 'package:rustic/views/library/tracks.dart';
import 'package:rustic/views/onboarding/onboarding.dart';
import 'package:rustic/views/player/player.dart';
import 'package:rustic/views/player/queue.dart';
import 'package:rustic/views/search/albums.dart';
import 'package:rustic/views/search/playlists.dart';
import 'package:rustic/views/search/search.dart';
import 'package:rustic/views/search/search_bloc.dart';
import 'package:rustic/views/servers/servers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = BlocLoggerDelegate();
  var notificationsService = NotificationsService();
  await notificationsService.setup();
  var prefs = await SharedPreferences.getInstance();
  runApp(RusticApp(
      notificationsService: notificationsService, sharedPreferences: prefs));
}

class RusticApp extends StatelessWidget {
  final NotificationsService notificationsService;
  final SharedPreferences sharedPreferences;

  RusticApp({this.notificationsService, this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServerBloc(sharedPreferences),
          ),
          BlocProvider(create: (BuildContext context) {
            var bloc = QueueBloc(serverBloc: context.bloc());
            bloc.add(FetchQueue());
            return bloc;
          }),
          BlocProvider(create: (BuildContext context) {
            var bloc = CurrentMediaBloc(serverBloc: context.bloc());
            bloc.add(FetchPlayer());

            return bloc;
          }),
          BlocProvider(create: (BuildContext context) {
            var bloc = ProviderBloc(serverBloc: context.bloc());
            bloc.add(FetchProviders());
            return bloc;
          }),
          BlocProvider(
            create: (BuildContext context) => SearchBloc(
                serverBloc: context.bloc(), providerBloc: context.bloc()),
          ),
          BlocProvider(
            create: (context) => ShareUrlBloc(context.bloc()),
          ),
        ],
        child: BlocBuilder<ServerBloc, ServerState>(
          builder: (context, state) {
            if (state.current == null) {
              return Onboarding();
            }
            return AppShell(notificationsService: notificationsService);
          },
        ));
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    Key key,
    @required this.notificationsService,
  }) : super(key: key);

  final NotificationsService notificationsService;

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentMediaBloc, Playing>(
      listener: (context, state) {
        ServerBloc bloc = context.bloc();
        this.widget.notificationsService.showNotification(bloc.getApi(), state);
      },
      child: MaterialApp(
        title: 'Rustic',
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.deepOrangeAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: AlbumsView.routeName,
        navigatorKey: _navigatorKey,
        builder: (context, widget) =>
            BlocListener<ShareUrlBloc, OpenResultModel>(
                listener: (context, state) {
                  if (state.type == 'album') {
                    AlbumModel album = AlbumModel(cursor: state.cursor);
                    _navigatorKey.currentState.pushNamed(AlbumView.routeName,
                        arguments: AlbumViewArguments(album));
                  }
                  if (state.type == 'playlist') {
                    // TODO: load full playlist
                    PlaylistModel playlist =
                        PlaylistModel(cursor: state.cursor);
                    _navigatorKey.currentState.pushNamed(PlaylistView.routeName,
                        arguments: PlaylistViewArguments(playlist));
                  }
                  // TODO: add support for tracks and artists
                },
                child: widget),
        routes: {
          AlbumsView.routeName: (context) => AlbumsView(),
          ArtistsView.routeName: (context) => ArtistsView(),
          TracksView.routeName: (context) => TracksView(),
          AlbumView.routeName: (context) => AlbumView(),
          PlaylistsView.routeName: (context) => PlaylistsView(),
          PlaylistView.routeName: (context) => PlaylistView(),
          SearchView.routeName: (context) => SearchView(),
          SearchAlbumView.routeName: (context) => SearchAlbumView(),
          SearchPlaylistView.routeName: (context) => SearchPlaylistView(),
          PlayerView.routeName: (context) => PlayerView(),
          QueueView.routeName: (context) => QueueView(),
          ServersView.routeName: (context) => ServersView()
        },
      ),
    );
  }
}
