import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:windows_wallpaper/service/unsplash_service.dart';
import 'package:windows_wallpaper/view/home_view.dart';

mixin HomeViewModel on State<HomeView> {
  late UnsplashService unsplashInstance;

  @override
  void initState() {
    unsplashInstance = UnsplashService(
        UnsplashClient(
          settings: const ClientSettings(
            credentials: AppCredentials(
              accessKey: 'unsplash_access_key',
              secretKey: 'unsplash_secret_key',
            ),
          ),
        ),
        30);
    super.initState();
  }
}
