import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rustic/api/api.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';

const HOST_PREFERENCES_KEY = 'HOST';

Future<String> getBaseUrl() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(HOST_PREFERENCES_KEY);
}

class HttpApi implements Api {
  String baseUrl;

  HttpApi({ this.baseUrl });

  Future<dynamic> fetchGeneric(String url) async {
    final res = await http.get('$baseUrl/api/$url');

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }else {
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
  Future<SearchResultModel> search(String query) async {
    print('search $query');
    var result = await fetchGeneric('search?query=$query');

    return SearchResultModel.fromJson(result);
  }

  @override
  Image fetchAlbumCoverart(AlbumModel album) {
    return Image.network('$baseUrl${album.coverart}');
  }

  @override
  Image fetchArtistImage(ArtistModel artist) {
    return Image.network('$baseUrl${artist.image}');
  }

  @override
  Image fetchCoverart(TrackModel track) {
    return Image.network('$baseUrl${track.coverart}');
  }
}
