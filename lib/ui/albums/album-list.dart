import 'package:flutter/material.dart';
import 'package:rustic/api/models/album.dart';
import 'package:rustic/ui/albums/album-card.dart';

class AlbumList extends StatelessWidget {
  final List<AlbumModel> albums;

  AlbumList({required this.albums});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: this.albums.map((album) => AlbumCard(album)).toList(),
    );
  }
}
