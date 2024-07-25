import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:windows_wallpaper/view_model/tile_view_model.dart';

class Tile extends StatefulWidget {
  final int index;
  final Photo photo;
  const Tile({
    super.key,
    required this.index,
    required this.photo,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with TileViewModel {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToDetails(),
      child: Hero(
        tag: widget.index,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.network(
              widget.photo.urls.thumb.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
