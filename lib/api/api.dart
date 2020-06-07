import 'package:flutter/widgets.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/player.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';

abstract class Api {
  Future<List<AlbumModel>> fetchAlbums();

  Future<List<ArtistModel>> fetchArtists();

  Future<List<TrackModel>> fetchTracks();

  Future<List<PlaylistModel>> fetchPlaylists();

  Future<SearchResultModel> search(String query);

  Future<void> playerPlay();

  Future<void> playerPause();

  Future<void> playerNext();

  Future<void> playerPrev();

  Future<PlayerModel> getPlayer();

  Image fetchAlbumCoverart(AlbumModel album);

  Image fetchArtistImage(ArtistModel artist);

  Image fetchCoverart(TrackModel track);

  Stream<SocketMessage> messages();
}
