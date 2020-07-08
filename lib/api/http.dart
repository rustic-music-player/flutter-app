import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http_logger/http_logger.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/open_result.dart';
import 'package:rustic/api/models/player.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/api/models/provider.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

const HOST_PREFERENCES_KEY = 'HOST';

Future<String> getBaseUrl() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(HOST_PREFERENCES_KEY);
}

class HttpApi implements Api {
  final String baseUrl;
  HttpWithMiddleware client;
  IOWebSocketChannel channel;
  Stream<SocketMessage> socketStream;

  String get apiUrl => 'http://$baseUrl/api';

  HttpApi({this.baseUrl}) {
    channel = connectSocket();
    client = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BASIC),
    ]);
  }

  IOWebSocketChannel connectSocket() =>
      IOWebSocketChannel.connect('ws://$baseUrl/api/socket');

  Future<dynamic> fetchGeneric(String url, {query}) async {
    String uri = query == null ? '$apiUrl/$url' : '$apiUrl/$url?$query';
    final res = await client.get(uri);

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
  Future<AlbumModel> fetchAlbum(String cursor) async {
    var res = await fetchGeneric('library/albums/$cursor');

    return AlbumModel.fromJson(res);
  }

  @override
  Future<void> addAlbumToLibrary(AlbumModel album) async {
    var res = await client.post('$apiUrl/library/albums/${album.cursor}');

    if (res.statusCode >= 400) {
      throw Exception("Invalid status code ${res.statusCode}");
    }
  }

  @override
  Future<void> removeAlbumFromLibrary(AlbumModel album) async {
    var res = await client.delete('$apiUrl/library/albums/${album.cursor}');

    if (res.statusCode >= 400) {
      throw Exception("Invalid status code ${res.statusCode}");
    }
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
  Future<SearchResultModel> search(String query, List<String> providers) async {
    print('search $query in providers: $providers');
    var providerQuery = [];
    providers.asMap().forEach((i, p) => providerQuery.add('&providers[$i]=$p'));
    var providerQueryString = providerQuery.join();
    var result =
        await fetchGeneric('search', query: 'query=$query$providerQueryString');

    return SearchResultModel.fromJson(result);
  }

  @override
  Future<PlayerModel> getPlayer() async {
    var player = await fetchGeneric('player');

    return PlayerModel.fromJson(player);
  }

  @override
  Future<void> playerPlay() async {
    await client.post('$apiUrl/player/play');
  }

  @override
  Future<void> playerPause() async {
    await client.post('$apiUrl/player/pause');
  }

  @override
  Future<void> playerNext() async {
    await client.post('$apiUrl/player/next');
  }

  @override
  Future<void> playerPrev() async {
    await client.post('$apiUrl/player/prev');
  }

  @override
  Future<void> setVolume(double volume) async {
    await client.post('$apiUrl/player/volume',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(volume));
  }

  @override
  Future<List<TrackModel>> getQueue() async {
    var queue = await fetchGeneric('queue');

    return queue.map<TrackModel>((t) => TrackModel.fromJson(t)).toList();
  }

  @override
  Future<void> queuePlaylist(String cursor) async {
    await client.post('$apiUrl/queue/playlist/$cursor');
  }

  @override
  Future<void> queueAlbum(String cursor) async {
    await client.post('$apiUrl/queue/album/$cursor');
  }

  @override
  Future<void> queueTrack(String cursor) async {
    await client.post('$apiUrl/queue/track/$cursor');
  }

  @override
  NetworkImage fetchCoverart(String url) {
    if (url == null) {
      return null;
    }
    return NetworkImage('http://$baseUrl$url');
  }

  @override
  Future<List<AvailableProviderModel>> fetchProviders() async {
    var providers = await fetchGeneric('providers/available');

    return providers
        .map<AvailableProviderModel>((p) => AvailableProviderModel.fromJson(p))
        .toList();
  }

  @override
  Stream<SocketMessage> messages() {
    if (socketStream == null) {
      socketStream = channel.stream.onErrorResume((e) {
        this.channel = connectSocket();
        return this.channel.stream;
      }).map((event) {
        var msg = SocketMessage.fromJson(jsonDecode(event));
        log('Socket $msg');
        return msg;
      }).asBroadcastStream();
    }
    return socketStream;
  }

  @override
  Future<String> getLocalCoverart(TrackModel track) async {
    return await _downloadAndSaveFile(
        'http://${this.baseUrl}${track.coverart}', track.cursor);
  }

  @override
  Future<void> setRepeat(RepeatMode repeat) async {
    var res = await client.post('$apiUrl/player/repeat',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(encodeRepeatMode(repeat)));
    if (res.statusCode >= 400) {
      throw Exception("Invalid status code ${res.statusCode}");
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/media-thumbnail-$fileName';
    var response = await client.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  @override
  Future<OpenResultModel> resolveShareUrl(Uri uri) async {
    var cursor = base64Encode(utf8.encode(uri.toString()));
    var res = await fetchGeneric('open/$cursor');

    var resultModel = OpenResultModel.fromJson(res);
    log('resolveShareUrl $uri => $resultModel');
    return resultModel;
  }
}
