import 'package:equatable/equatable.dart';
import 'package:music_app/domain/entities/track/track.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final List<TrackEntity> songs;

  const SongLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

class SongError extends SongState {
  final String message;

  const SongError(this.message);

  @override
  List<Object> get props => [message];
}
