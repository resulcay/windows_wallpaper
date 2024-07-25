import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windows_wallpaper/component/tile.dart';
import 'package:windows_wallpaper/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: unsplashInstance.getRandomImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
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
