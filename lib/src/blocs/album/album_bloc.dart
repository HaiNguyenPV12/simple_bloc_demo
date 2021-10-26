import 'package:bloc/bloc.dart';

import '../../services/album_service/album_service.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumService? service;

  AlbumBloc({this.service}) : super(AlbumInitial()) {
    on<AlbumRequested>((event, emit) async {
      try {
        emit(AlbumLoadInProgress());

        // Forced delay for demo
        // await Future.delayed(const Duration(seconds: 2));

        emit(AlbumLoadSucess(albums: await service!.fetchAlbum()));
      } catch (e) {
        emit(AlbumLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
