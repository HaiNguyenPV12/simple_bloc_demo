import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../config/constants.dart';
import '../../models/Album.dart';
import 'album_service.dart';

class AppAlbumService extends AlbumService {
  AppAlbumService(http.Client client) : super(client);

  Future<List<Album>> fetchAlbum() async {
    final uri = Uri(
      scheme: 'https',
      host: AppConfig.instance.getValue(AppConstants.HOST_NAME),
      path: AppConfig.instance.getValue(AppConstants.ALBUM_PATH),
    );

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      Iterable responseList = json.decode(response.body);
      var albums =
          List<Album>.from(responseList.map((model) => Album.fromJson(model)));

      return albums;
    } else {
      throw Exception('Failed to load album list');
    }
  }
}
