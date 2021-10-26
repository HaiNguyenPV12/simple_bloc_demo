import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_bloc.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_event.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_state.dart';
import 'package:simple_bloc_demo/src/services/album_service/album_service.dart';

class MockAlbumService extends Mock implements AlbumService {}

class MockAlbumEvent extends AlbumEvent {}

main() {
  AlbumService albumService;
  AlbumBloc? albumBloc;

  setUp(() {
    albumService = MockAlbumService();
    albumBloc = AlbumBloc(service: albumService);
  });

  tearDown(() {
    albumBloc?.close();
  });

  blocTest('emits [] when no event is added',
      build: () => AlbumBloc(), expect: () => []);

  blocTest(
    'emits [AlbumLoadFailure] when invalid event is called',
    build: () {
      albumService = MockAlbumService();
      return AlbumBloc(service: albumService);
    },
    act: (AlbumBloc bloc) => bloc.add(MockAlbumEvent()),
    expect: () => [AlbumLoadFailure()],
  );

  blocTest(
    'emits [AlbumLoadInProgress] then [AlbumLoadSucess] when [AlbumRequested] is called',
    build: () {
      albumService = MockAlbumService();
      return AlbumBloc(service: albumService);
    },
    act: (AlbumBloc bloc) => bloc.add(AlbumRequested()),
    expect: () => [
      AlbumLoadInProgress(),
      AlbumLoadSucess(),
    ],
  );

  blocTest(
    'emits [AlbumLoadFailure] when [AlbumRequested] is called and service throws error.',
    build: () {
      albumService = MockAlbumService();
      when(albumService.fetchAlbum()).thenThrow(Exception());
      return AlbumBloc(service: albumService);
    },
    act: (AlbumBloc bloc) => bloc.add(AlbumRequested()),
    expect: () => [
      AlbumLoadInProgress(),
      AlbumLoadFailure(errorMessage: Exception().toString()),
    ],
  );
}
