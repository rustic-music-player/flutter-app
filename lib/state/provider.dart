import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/views/search/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'extensions_bloc.dart';
import 'library/artist_library_bloc.dart';
import 'library/playlist_library_bloc.dart';
import 'library/track_library_bloc.dart';
import 'media_bloc.dart';
import 'provider_bloc.dart';
import 'queue_bloc.dart';
import 'server_bloc.dart';
import 'share_url_bloc.dart';

class StateProvider extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Widget child;

  const StateProvider({ required this.sharedPreferences, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServerBloc(sharedPreferences),
          ),
          BlocProvider(create: (BuildContext context) {
            var bloc = QueueBloc(serverBloc: context.read());
            bloc.add(FetchQueue());
            return bloc;
          }),
          BlocProvider(create: (BuildContext context) {
            var bloc = CurrentMediaBloc(serverBloc: context.read());
            bloc.add(FetchPlayer());

            return bloc;
          }),
          BlocProvider(create: (BuildContext context) {
            var bloc = ProviderBloc(serverBloc: context.read());
            bloc.add(FetchProviders());
            return bloc;
          }),
          BlocProvider(
            create: (BuildContext context) => SearchBloc(
                serverBloc: context.read(), providerBloc: context.read()),
          ),
          BlocProvider(
            create: (context) => ShareUrlBloc(context.read()),
          ),
          BlocProvider(
            create: (context) => TrackLibraryBloc(context.read()),
          ),
          BlocProvider(
            create: (context) => PlaylistLibraryBloc(context.read()),
          ),
          BlocProvider(
            create: (context) => ArtistLibraryBloc(context.read()),
          ),
          BlocProvider(
            create: (context) => ExtensionsBloc(context.read()),
          ),
        ],
        child: child);
  }
}
