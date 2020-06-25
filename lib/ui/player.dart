import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/media_bloc.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/views/player/player.dart';

class RusticPlayerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentMediaBloc, Playing>(
      builder: (context, state) {
        ServerBloc bloc = context.bloc();
        if (state.track == null) {
          return Container();
        }
        return GestureDetector(
          child: Container(
            height: 64,
            color: Color.fromARGB(255, 32, 32, 32),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Hero(
                    tag: 'now-playing',
                    child: Image(
                        image: bloc.getApi().fetchCoverart(state.track.coverart)),
                  ),
                ),
                CurrentlyPlayingText(state.track),
                IconButton(
                  icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () => state.isPlaying
                      ? bloc.getApi().playerPause()
                      : bloc.getApi().playerPlay(),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () => bloc.getApi().playerNext(),
                )
              ],
            ),
          ),
          onTap: () => Navigator.pushNamed(context, PlayerView.routeName),
        );
      },
    );
  }
}

class CurrentlyPlayingText extends StatelessWidget {
  final TrackModel track;

  const CurrentlyPlayingText(
    this.track, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              track?.title ?? '',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            track.artist?.name ?? '',
            style: TextStyle(fontSize: 12, color: Colors.white70),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ));
  }
}
