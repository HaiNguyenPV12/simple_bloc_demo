import 'package:http/http.dart' as http;

import '../../models/Album.dart';

abstract class AlbumService {
  final http.Client client;

  AlbumService(this.client);

  Future<List<Album>>? fetchAlbum();
}
