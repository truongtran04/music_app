import 'package:equatable/equatable.dart';
import 'package:music_app/domain/entities/album/album.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<AlbumEntity> albums;

  const AlbumLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object> get props => [message];
}