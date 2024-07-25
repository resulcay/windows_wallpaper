import 'package:flutter/material.dart';
import 'package:windows_wallpaper/component/tile.dart';
import 'package:windows_wallpaper/view/image_detail_view.dart';

mixin TileViewModel on State<Tile> {
  void navigateToDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ImageDetailView(
            index: widget.index,
            url: widget.photo.urls.raw.toString(),
          );
        },
      ),
    );
  }
}
