import 'package:flutter/material.dart';
import 'package:windows_wallpaper/view_model/image_detail_view_model.dart';

class ImageDetailView extends StatefulWidget {
  const ImageDetailView({
    super.key,
    required this.index,
    required this.url,
  });

  final int index;
  final String url;

  @override
  State<ImageDetailView> createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView>
    with ImageDetailViewModel {
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
              tag: widget.index,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.cover,
                  ),
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
                      setAsBackground(context, widget.index);
                    },
                    child: const Text('Set as Background'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      downloadImage(context, widget.index);
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
