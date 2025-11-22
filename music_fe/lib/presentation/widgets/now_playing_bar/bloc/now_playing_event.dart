import '../../../../domain/entities/track/track.dart';

abstract class PlayingSongEvent {}

class PlaySongEvent extends PlayingSongEvent {
  final TrackEntity song;
  PlaySongEvent(this.song);
}

class TogglePlayPauseEvent extends PlayingSongEvent {}

class UpdateProgressEvent extends PlayingSongEvent {
  final Duration position;
  UpdateProgressEvent(this.position);
}

// New events for playlist control
class PlayPlaylistEvent extends PlayingSongEvent {
  final List<TrackEntity> playlist;
  final int initialIndex;
  
  PlayPlaylistEvent({
    required this.playlist,
    this.initialIndex = 0,
  });
}

class NextSongEvent extends PlayingSongEvent {}

class PreviousSongEvent extends PlayingSongEvent {}

class ToggleShuffleEvent extends PlayingSongEvent {}

class ToggleRepeatEvent extends PlayingSongEvent {}

class JumpToTrackEvent extends PlayingSongEvent {
  final int index;
  JumpToTrackEvent(this.index);
}