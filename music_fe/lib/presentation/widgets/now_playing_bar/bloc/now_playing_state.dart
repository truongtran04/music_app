import '../../../../domain/entities/track/track.dart';

enum RepeatMode {
  none,    // Không lặp
  all,     // Lặp toàn bộ playlist
  one,     // Lặp một bài
}

abstract class PlayingSongState {}

class PlayingSongInitial extends PlayingSongState {}

class SongPlaying extends PlayingSongState {
  final TrackEntity song;
  final bool isPlaying;
  final Duration position;
  final List<TrackEntity> playlist;
  final int currentIndex;
  final bool isShuffled;
  final RepeatMode repeatMode;
  final List<int> shuffledOrder; // Thứ tự ngẫu nhiên

  SongPlaying({
    required this.song,
    this.isPlaying = true,
    this.position = Duration.zero,
    this.playlist = const [],
    this.currentIndex = 0,
    this.isShuffled = false,
    this.repeatMode = RepeatMode.none,
    this.shuffledOrder = const [],
  });

  // Helper methods với null safety
  bool? get hasNext {
    if (playlist.isEmpty) return null;
    if (repeatMode == RepeatMode.one || repeatMode == RepeatMode.all) return true;
    if (isShuffled) return shuffledOrder.length > 1;
    return currentIndex < playlist.length - 1;
  }

  bool? get hasPrevious {
    if (playlist.isEmpty) return null;
    if (repeatMode == RepeatMode.one || repeatMode == RepeatMode.all) return true;
    if (isShuffled) return shuffledOrder.length > 1;
    return currentIndex > 0;
  }

  SongPlaying copyWith({
    TrackEntity? song,
    bool? isPlaying,
    Duration? position,
    List<TrackEntity>? playlist,
    int? currentIndex,
    bool? isShuffled,
    RepeatMode? repeatMode,
    List<int>? shuffledOrder,
  }) {
    return SongPlaying(
      song: song ?? this.song,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      isShuffled: isShuffled ?? this.isShuffled,
      repeatMode: repeatMode ?? this.repeatMode,
      shuffledOrder: shuffledOrder ?? this.shuffledOrder,
    );
  }
}