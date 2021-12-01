import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bloc_demo/src/models/Album.dart';

void main() {
  Album albumModel = Album(
    albumId: 1,
    id: 1,
    thumbnailUrl: 'https://via.placeholder.com/150/92c952',
    title: 'accusamus beatae ad facilis cum similique qui sunt',
    url: 'https://via.placeholder.com/600/92c952',
  );

  Map<String, dynamic> mappedAlbum = {
    'albumId': 1,
    'id': 1,
    'thumbnailUrl': 'https://via.placeholder.com/150/92c952',
    'title': 'accusamus beatae ad facilis cum similique qui sunt',
    'url': 'https://via.placeholder.com/600/92c952',
  };

  test('Should be able export Album to json with valid model', () {
    var data = albumModel.toJson();
    expect(data, mappedAlbum);
  });

  test('Should be able to retrieve Album\'s properties', () {
    final albumToCompare = Album.fromJson(mappedAlbum);
    expect(albumModel == albumToCompare, true);
  });
}
