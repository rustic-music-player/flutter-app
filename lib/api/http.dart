import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/player.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

const HOST_PREFERENCES_KEY = 'HOST';

Future<String> getBaseUrl() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(HOST_PREFERENCES_KEY);
}

class HttpApi implements Api {
  final String baseUrl;
  IOWebSocketChannel channel;
  Stream<SocketMessage> socketStream;

  String get apiUrl => 'http://$baseUrl/api';

  HttpApi({this.baseUrl}) {
    channel = IOWebSocketChannel.connect('ws://$baseUrl/api/socket');
  }

  Future<dynamic> fetchGeneric(String url) async {
    log('GET $url');
    final res = await http.get('$apiUrl/$url');

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load $url');
    }
  }

  @override
  Future<List<AlbumModel>> fetchAlbums() async {
    var list = await fetchGeneric('library/albums');

    return list.map<AlbumModel>((a) => AlbumModel.fromJson(a)).toList();
  }

  @override
  Future<List<ArtistModel>> fetchArtists() async {
    var list = await fetchGeneric('library/artists');

    return list.map<ArtistModel>((a) => ArtistModel.fromJson(a)).toList();
  }

  @override
  Future<List<TrackModel>> fetchTracks() async {
    var list = await fetchGeneric('library/tracks');

    return list.map<TrackModel>((a) => TrackModel.fromJson(a)).toList();
  }

  @override
  Future<List<PlaylistModel>> fetchPlaylists() async {
    var list = await fetchGeneric('library/playlists');

    return list.map<PlaylistModel>((a) => PlaylistModel.fromJson(a)).toList();
  }

  @override
  Future<SearchResultModel> search(String query) async {
    print('search $query');
    var result = await fetchGeneric('search?query=$query');

    return SearchResultModel.fromJson(result);
  }

  @override
  Future<void> playerPlay() async {
    await http.post('$apiUrl/player/play');
  }

  @override
  Future<void> playerPause() async {
    await http.post('$apiUrl/player/pause');
  }

  @override
  Future<void> playerNext() async {
    await http.post('$apiUrl/player/next');
  }

  @override
  Future<void> playerPrev() async {
    await http.post('$apiUrl/player/prev');
  }

  @override
  Future<PlayerModel> getPlayer() async {
    var player = await fetchGeneric('player');

    return PlayerModel.fromJson(player);
  }

  @override
  Future<List<TrackModel>> getQueue() async {
    var queue = await fetchGeneric('queue');

    return queue.map<TrackModel>((t) => TrackModel.fromJson(t)).toList();
  }

  @override
  Future<void> queuePlaylist(String cursor) async {
    await http.post('$apiUrl/queue/playlist/$cursor');
  }

  @override
  Future<void> queueAlbum(String cursor) async {
    await http.post('$apiUrl/queue/album/$cursor');
  }

  @override
  Future<void> queueTrack(String cursor) async {
    await http.post('$apiUrl/queue/track/$cursor');
  }

  @override
  NetworkImage fetchCoverart(String url) {
    if (url == null) {
      return null;
    }
    return NetworkImage('http://$baseUrl$url');
  }

  @override
  Stream<SocketMessage> messages() {
    if (socketStream == null) {
      socketStream = channel.stream.map((event) {
        var msg = SocketMessage.fromJson(jsonDecode(event));
        log('Socket $msg');
        return msg;
      }).asBroadcastStream();
    }
    return socketStream;
  }
}
