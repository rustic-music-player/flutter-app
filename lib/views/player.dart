import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/media_bloc.dart';

class PlayerView extends StatelessWidget {
  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    var api = context.repository<Api>();
    return BlocBuilder<CurrentMediaBloc, Playing>(
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 32, 32, 32),
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.queue_music, color: Colors.white),
                  )
                ],
                title: Text(state.track.title),
                centerTitle: true,
                elevation: 0,
              ),
              backgroundColor: Color.fromARGB(255, 32, 32, 32),
              body: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    foregroundDecoration: BoxDecoration(
                        image: DecorationImage(
                            image: api.fetchCoverart(state.track.coverart),
                            fit: BoxFit.contain)),
                    margin: EdgeInsets.all(16),
                  )),
                  Expanded(child: PlayerControls(state.isPlaying))
                ],
              ),
            ));
  }
}

class PlayerControls extends StatelessWidget {
  final bool isPlaying;

  PlayerControls(this.isPlaying);

  @override
  Widget build(BuildContext context) {
    Api api = context.repository();

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
          ),
          iconSize: 32,
          onPressed: () => api.playerPrev(),
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          iconSize: 48,
          onPressed: () => isPlaying ? api.playerPause() : api.playerPlay(),
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: Colors.white),
          iconSize: 32,
          onPressed: () => api.playerNext(),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
