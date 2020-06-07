import 'package:flutter/widgets.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/track.dart';

abstract class Api {
  Future<List<AlbumModel>> fetchAlbums();
  Future<List<ArtistModel>> fetchArtists();
  Future<List<TrackModel>> fetchTracks();
  Future<SearchResultModel> search(String query);

  Image fetchAlbumCoverart(AlbumModel album);
  Image fetchArtistImage(ArtistModel artist);
  Image fetchCoverart(TrackModel track);
}
