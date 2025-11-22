import 'package:equatable/equatable.dart';

abstract class AlbumDetailEvent extends Equatable {
  const AlbumDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchAlbumDetail extends AlbumDetailEvent {
  final String albumId;

  const FetchAlbumDetail(this.albumId);

  @override
  List<Object> get props => [albumId];
}

class FetchAlbumTracks extends AlbumDetailEvent {
  final String albumId;

  const FetchAlbumTracks(this.albumId);

  @override
  List<Object> get props => [albumId];
}