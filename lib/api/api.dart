import 'package:flutter/widgets.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/api/models/artist.dart';
import 'package:rustic/api/models/player.dart';
import 'package:rustic/api/models/playlist.dart';
import 'package:rustic/api/models/provider.dart';
import 'package:rustic/api/models/search.dart';
import 'package:rustic/api/models/socket_msg.dart';
import 'package:rustic/api/models/track.dart';

abstract class Api {
  Future<List<AlbumModel>> fetchAlbums();

  Future<List<ArtistModel>> fetchArtists();

  Future<List<TrackModel>> fetchTracks();

  Future<List<PlaylistModel>> fetchPlaylists();

  Future<SearchResultModel> search(String query, List<String> providers);

  Future<PlayerModel> getPlayer();

  Future<void> playerPlay();

  Future<void> playerPause();

  Future<void> playerNext();

  Future<void> playerPrev();

  Future<void> setVolume(double volume);

  Future<List<TrackModel>> getQueue();

  Future<void> queuePlaylist(String cursor);

  Future<void> queueAlbum(String cursor);

  Future<void> queueTrack(String cursor);

  NetworkImage fetchCoverart(String url);

  Future<List<AvailableProviderModel>> fetchProviders();

  Stream<SocketMessage> messages();
}
