import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/media_bloc.dart';
import 'package:rustic/views/player.dart';

class RusticPlayerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    var bloc = context.bloc<CurrentMediaBloc>();
    bloc.add(FetchPlayers);
    return BlocBuilder<CurrentMediaBloc, Playing>(
      builder: (context, state) {
        if (state.track == null) {
          return Container();
        }
        return GestureDetector(
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: Image(image: api.fetchCoverart(state.track.coverart)),
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
          ),
          onTap: () => Navigator.pushNamed(context, PlayerView.routeName),
        );
      },
    );
  }
}
