import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/media_bloc.dart';

class RusticPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    var bloc = context.bloc<CurrentMediaBloc>();
    bloc.add(FetchPlayers);
    return BlocBuilder<CurrentMediaBloc, Playing>(
      builder: (context, state) {
        return AppBar(
          automaticallyImplyLeading: false,
          leading: api.fetchCoverart(state.track),
          title: Text(state.track?.title ?? ''),
          actions: <Widget>[
            IconButton(
              icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () =>
                  state.isPlaying ? api.playerPause() : api.playerPlay(),
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () => api.playerNext(),
            )
          ],
        );
      },
    );
  }
}
