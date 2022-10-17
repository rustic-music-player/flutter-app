import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/state/media_bloc.dart';
import 'package:rustic/state/server_bloc.dart';

class PlayerCoverArt extends StatelessWidget {
  PlayerCoverArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServerBloc bloc = context.read();
    return BlocBuilder<CurrentMediaBloc, Playing>(
      buildWhen: (prev, next) => prev.track?.coverart != next.track?.coverart,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black26, spreadRadius: 5, blurRadius: 5, offset: Offset(0, 2))
              ]),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(const Radius.circular(4)),
                  child: _buildCoverart(state, bloc)),
            ),
          ),
        );
      },
    );
  }

  Widget? _buildCoverart(Playing state, ServerBloc bloc) {
    if (state.track?.coverart == null) {
      return null;
    }
    NetworkImage? coverart = bloc.getApi()?.fetchCoverart(state.track!.coverart!);
    if (coverart == null) {
      return null;
    }

    return Hero(
        tag: 'now-playing',
        child: Image(
          key: Key(state.track!.coverart!),
          image: coverart,
          fit: BoxFit.contain,
        ));
  }
}
