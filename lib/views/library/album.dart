import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rustic/state/server_bloc.dart';
import 'package:rustic/ui/coverart.dart';
import 'package:rustic/ui/player.dart';

class AlbumViewArguments {
  final AlbumModel album;

  AlbumViewArguments(this.album);
}

class AlbumView extends StatelessWidget {
  static const routeName = '/album';

  @override
  Widget build(BuildContext context) {
    final AlbumViewArguments args =
        ModalRoute.of(context)!.settings.arguments! as AlbumViewArguments;
    final ServerBloc bloc = context.read();
    final Api api = bloc.getApi()!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.black54,
        body: Column(children: <Widget>[
          FutureBuilder<AlbumModel>(
            future: api.fetchAlbum(args.album.cursor),
            builder: (context, snapshot) {
              final bool mobile = MediaQuery.of(context).size.shortestSide < 600;
              if (mobile) {
                return Expanded(child: _mobileView(api, args, snapshot.data));
              } else {
                return Expanded(child: _desktopView(api, args, snapshot.data));
              }
            },
          ),
          RusticPlayerBar()
        ]));
  }

  Widget _mobileView(Api api, AlbumViewArguments args, AlbumModel? album) {
    if (album != null) {
      return Expanded(
          child: ListView(children: [
        AlbumHeader(api, album),
        ...album.tracks
            .map<Widget>((t) => ListTile(
                  title: Text(t.title),
                  subtitle: mapDuration(t),
                  leading: CircleAvatar(child: Text(t.position?.track?.toString() ?? "")),
                  onTap: () => api.queueTrack(t.cursor),
                ))
            .toList(),
        Padding(
          padding: const EdgeInsets.all(8.0).add(EdgeInsets.only(bottom: 8)),
          child: Text('${album.tracks.length} Tracks',
              style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
        )
      ]));
    }
    return Expanded(
        child: ListView(children: [AlbumHeader(api, args.album), LinearProgressIndicator()]));
  }

  Widget _desktopView(Api api, AlbumViewArguments args, AlbumModel? album) {
    if (album != null) {
      return Row(children: [
        Flexible(child: AlbumHeader(api, album), flex: 1),
        Flexible(
            child: ListView(children: [
              ...album.tracks
                  .map<Widget>((t) => ListTile(
                        title: Text(t.title),
                        subtitle: mapDuration(t),
                        leading: CircleAvatar(child: Text(t.position?.track?.toString() ?? "")),
                        onTap: () => api.queueTrack(t.cursor),
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.all(8.0).add(EdgeInsets.only(bottom: 8)),
                child: Text('${album.tracks.length} Tracks',
                    style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
              )
            ]),
            flex: 2),
      ]);
    }
    return Row(children: [
      Flexible(child: AlbumHeader(api, args.album), flex: 1),
      Flexible(child: LinearProgressIndicator(), flex: 1)
    ]);
  }

  Text? mapDuration(TrackModel track) {
    if (track.duration == null) {
      return null;
    }
    var duration = Duration(seconds: track.duration!);
    var seconds = duration.inSeconds - (duration.inMinutes * Duration.secondsPerMinute);
    return Text('${duration.inMinutes}:${seconds.toString().padLeft(2, '0')}');
  }
}

class AlbumHeader extends StatelessWidget {
  final Api api;
  final AlbumModel album;

  const AlbumHeader(this.api, this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).size.shortestSide < 600;

    if (mobile) {
      return _mobileView();
    } else {
      return _desktopView();
    }
  }

  Widget _mobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 2, child: AlbumCover(api, album)),
              Expanded(flex: 3, child: AlbumMeta(api, album)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _desktopView() {
    return Column(
      children: [
        AlbumCover(api, album),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AlbumMeta(api, album),
        ),
      ],
    );
  }
}

class AlbumCover extends StatelessWidget {
  final Api api;
  final AlbumModel album;

  const AlbumCover(this.api, this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 16.0),
        child: TextButton(
          onPressed: () => api.queueAlbum(album.cursor),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            album.coverart != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(const Radius.circular(4)),
                    child: Hero(tag: album.cursor, child: Coverart(album: album)),
                  )
                : Container(),
            Icon(Icons.play_circle_filled, size: 64, color: Colors.white70)
          ]),
        ));
  }
}

class AlbumMeta extends StatelessWidget {
  final Api api;
  final AlbumModel album;

  const AlbumMeta(this.api, this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(album.title ?? '', style: TextStyle(fontSize: 20)),
          Text(album.artist?.name ?? '', style: TextStyle(fontSize: 14, color: Colors.white54)),
          LibraryButton(this.api, this.album)
        ],
      ),
    );
  }
}

class LibraryButton extends StatefulWidget {
  final AlbumModel album;
  final Api api;

  const LibraryButton(
    this.api,
    this.album, {
    Key? key,
  }) : super(key: key);

  @override
  _LibraryButtonState createState() => _LibraryButtonState(album.inLibrary ?? false);
}

class _LibraryButtonState extends State<LibraryButton> {
  bool inLibrary;

  _LibraryButtonState(this.inLibrary);

  @override
  Widget build(BuildContext context) {
    if (inLibrary) {
      return OutlinedButton(
          onPressed: () =>
              widget.api.removeAlbumFromLibrary(widget.album).then((value) => this.setState(() {
                    this.inLibrary = false;
                  })),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.check),
              ),
              Text('In Library'),
            ],
          ));
    }
    return OutlinedButton(
      onPressed: () => widget.api.addAlbumToLibrary(widget.album).then((value) => this.setState(() {
            this.inLibrary = true;
          })),
      // color: Colors.deepOrange,
      child: Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.add)),
          Text('Add to Library')
        ],
      ),
    );
  }
}
