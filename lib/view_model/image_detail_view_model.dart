import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';
import 'package:windows_wallpaper/view/image_detail_view.dart';
import 'package:http/http.dart' as http;

mixin ImageDetailViewModel on State<ImageDetailView> {
  Future<void> downloadImage(BuildContext context, int index) async {
    File file = await _imageOpeation(index, widget.url);

    if (context.mounted) {
      _showMessage(context, 'Downloaded successfully: ${file.path}');
    }
  }

  Future<File> _imageOpeation(int index, String path) async {
    final response = await http.get(Uri.parse(path));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$index.jpg');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> setAsBackground(BuildContext context, int index) async {
    File file = await _imageOpeation(index, widget.url);

    try {
      const spifUpdateinifile = 0x01;
      const spifSendchange = 0x02;

      final result = SystemParametersInfo(
        SPI_SETDESKWALLPAPER,
        0,
        TEXT(file.path),
        spifUpdateinifile | spifSendchange,
      );

      if (result != 0) {
        if (context.mounted) {
          _showMessage(context, 'Set as background successfully');
        }
      } else {
        if (context.mounted) {
          _showMessage(context, 'Failed to set as background');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, e.toString());
      }
    } finally {
      file.delete();
    }
  }

  void _showMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
