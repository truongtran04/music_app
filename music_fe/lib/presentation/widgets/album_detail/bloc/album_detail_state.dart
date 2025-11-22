import 'package:equatable/equatable.dart';
import 'package:music_app/domain/entities/album/album.dart';
import 'package:music_app/domain/entities/track/track.dart';

abstract class AlbumDetailState extends Equatable {
  const AlbumDetailState();

  @override
  List<Object> get props => [];
}

class AlbumDetailInitial extends AlbumDetailState {}

class AlbumDetailLoading extends AlbumDetailState {}

class AlbumDetailLoaded extends AlbumDetailState {
  final AlbumEntity album;
  final List<TrackEntity> tracks;

  const AlbumDetailLoaded({
    required this.album,
    required this.tracks,
  });

  @override
  List<Object> get props => [album, tracks];
}

class AlbumDetailError extends AlbumDetailState {
  final String message;

  const AlbumDetailError(this.message);

  @override
  List<Object> get props => [message];
}