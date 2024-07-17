import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';

const SPI_SETDESKWALLPAPER = 0x0014;
const SPIF_UPDATEINIFILE = 0x01;
const SPIF_SENDCHANGE = 0x02;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windows Wallpaper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Windows Wallpaper'),
      ),
      body: MasonryGridView.count(
        itemCount: 180,
        crossAxisCount: 6,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return Tile(index: index);
        },
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;
  const Tile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ImageDetailWidget(index: index);
            },
          ),
        );
      },
      child: Hero(
        tag: index,
        child: Image.network(
          'https://picsum.photos/200/300?random=$index',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ImageDetailWidget extends StatelessWidget {
  const ImageDetailWidget({
    super.key,
    required this.index,
  });

  final int index;

  Future<void> downloadImage(BuildContext context, int index) async {
    final url = 'https://picsum.photos/200/300?random=$index';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/image_$index.jpg');
    await file.writeAsBytes(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded to ${file.path}')),
    );
  }

  Future<void> setAsBackground(BuildContext context, int index) async {
    final url = 'https://picsum.photos/200/300?random=$index';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/image_$index.jpg');
    await file.writeAsBytes(bytes);

    try {
      final result = SystemParametersInfo(
        SPI_SETDESKWALLPAPER,
        0,
        TEXT(file.path),
        SPIF_UPDATEINIFILE | SPIF_SENDCHANGE,
      );

      if (result != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully set as background')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to set as background')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set as background: $e')),
      );
    } finally {
      file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Details'),
      ),
      body: Center(
        child: Stack(
          children: [
            Hero(
              tag: index,
              child: Image.network(
                width: MediaQuery.of(context).size.width * 0.6,
                'https://picsum.photos/200/300?random=$index',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setAsBackground(context, index);
                    },
                    child: const Text('Set as Background'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      downloadImage(context, index);
                    },
                    child: const Text('Download'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
