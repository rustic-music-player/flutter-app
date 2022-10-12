import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';

class Coverart extends StatelessWidget {
  TrackModel? track;
  AlbumModel? album;
  ArtistModel? artist;

  Coverart({this.track, this.album, this.artist, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServerBloc bloc = context.read();

    if (coverartUrl == null) {
      return Container();
    }

    var image = bloc.getApi()?.fetchCoverart(coverartUrl!);

    if (image == null) {
      return Container();
    }

    return Image(image: image);
  }

  String? get coverartUrl {
    return track?.coverart ?? album?.coverart ?? artist?.image;
  }
}
