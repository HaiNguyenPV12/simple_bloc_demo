import 'package:equatable/equatable.dart';

import '../../models/Album.dart';

abstract class AlbumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoadFailure extends AlbumState {
  final String? errorMessage;

  AlbumLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AlbumLoadInProgress extends AlbumState {}

class AlbumLoadSucess extends AlbumState {
  final List<Album>? albums;

  AlbumLoadSucess({this.albums});

  @override
  List<Object?> get props => [albums];
}
