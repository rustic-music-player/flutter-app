import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';

class PlayerCoverArt extends StatelessWidget {
  final String coverart;

  PlayerCoverArt(this.coverart, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Api api = context.repository();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(const Radius.circular(4)),
            child: Image(
              image: api.fetchCoverart(coverart),
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}
