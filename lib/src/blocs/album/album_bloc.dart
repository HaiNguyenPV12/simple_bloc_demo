import 'package:bloc/bloc.dart';

import '../../services/album_service/album_service.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumService? service;

  AlbumBloc({this.service}) : super(AlbumInitial());

  @override
  Stream<AlbumState> mapEventToState(AlbumEvent event) async* {
    switch (event.runtimeType) {
      case AlbumRequested:
        try {
          yield AlbumLoadInProgress();

          // Forced delay for demo
          // await Future.delayed(const Duration(seconds: 2));

          yield AlbumLoadSucess(albums: await service!.fetchAlbum());
        } catch (e) {
          yield AlbumLoadFailure(errorMessage: e.toString());
        }
        break;
      default:
        yield AlbumLoadFailure();
        break;
    }
  }
}
