import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:win32/win32.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'Windows Wallpaper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: lightDynamic ??
              ColorScheme.fromSwatch(primarySwatch: Colors.purple),
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? const ColorScheme.dark(),
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      );
    });
  }
}

final client = UnsplashClient(
  settings: const ClientSettings(
    credentials: AppCredentials(
      accessKey: 'unsplash_access_key',
      secretKey: 'unsplash_secret_key',
    ),
  ),
);

Future<List<Photo>> getRandomImage() async {
  var photo = client.photos.random(count: 30).goAndGet();
  var photoPath = photo;

  return photoPath;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRandomImage(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Windows Wallpaper'),
          ),
          body: MasonryGridView.builder(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Tile(index: index, photo: snapshot.data![index]);
            },
          ),
        );
      },
    );
  }
}

class Tile extends StatelessWidget {
  final int index;
  final Photo photo;
  const Tile({
    super.key,
    required this.index,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ImageDetailWidget(
                index: index,
                url: photo.urls.raw.toString(),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: index,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.network(
            photo.urls.thumb.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ImageDetailWidget extends StatelessWidget {
  const ImageDetailWidget({
    super.key,
    required this.index,
    required this.url,
  });

  final int index;
  final String url;

  Future<void> downloadImage(BuildContext context, int index) async {
    File file = await _imageOpeation(index, url);

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
    File file = await _imageOpeation(index, url);

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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
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
                  const SizedBox(width: 10),
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
