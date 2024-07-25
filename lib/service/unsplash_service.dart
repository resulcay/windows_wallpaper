import 'package:unsplash_client/unsplash_client.dart';

final class UnsplashService {
  final UnsplashClient client;
  final int count;

  UnsplashService(this.client, this.count);

  Future<List<Photo>> getRandomImage() async {
    var photo = client.photos.random(count: count).goAndGet();
    var photoPath = photo;

    return photoPath;
  }
}
