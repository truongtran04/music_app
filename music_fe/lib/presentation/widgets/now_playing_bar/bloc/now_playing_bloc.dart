import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'now_playing_event.dart';
import 'now_playing_state.dart';

class PlayingSongBloc extends Bloc<PlayingSongEvent, PlayingSongState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<ProcessingState>? _processingStateSubscription;
  final Random _random = Random();

  PlayingSongBloc() : super(PlayingSongInitial()) {
    on<PlaySongEvent>(_onPlaySong);
    on<PlayPlaylistEvent>(_onPlayPlaylist);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<NextSongEvent>(_onNextSong);
    on<PreviousSongEvent>(_onPreviousSong);
    on<ToggleShuffleEvent>(_onToggleShuffle);
    on<ToggleRepeatEvent>(_onToggleRepeat);
    on<JumpToTrackEvent>(_onJumpToTrack);

    _initializeListeners();
  }

  void _initializeListeners() {
    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      if (state is SongPlaying) {
        final current = state as SongPlaying;
        final isPlaying = playerState.playing;

        if (current.isPlaying != isPlaying) {
          emit(current.copyWith(isPlaying: isPlaying));
        }
      }
    });

    // Listen for processing state changes (for song completion)
    _processingStateSubscription = _audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        _onSongCompleted();
      }
    });
  }

  void _onSongCompleted() {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      switch (current.repeatMode) {
        case RepeatMode.one:
          // Repeat current song
          add(PlaySongEvent(current.song));
          break;
        case RepeatMode.all:
          // Play next song, if end then go to beginning
          add(NextSongEvent());
          break;
        case RepeatMode.none:
          // Play next song if available, otherwise stop
          if (current.hasNext == true) {
            add(NextSongEvent());
          } else {
            // Stop playing but keep the state
            emit(current.copyWith(isPlaying: false));
          }
          break;
      }
    }
  }

  Future<void> _onPlaySong(PlaySongEvent event, Emitter<PlayingSongState> emit) async {
    try {
      await _stopCurrentPlayback();

      // If currently playing and song exists in current playlist, just update index
      if (state is SongPlaying) {
        final current = state as SongPlaying;
        final songIndex = current.playlist.indexWhere((track) => track.id == event.song.id);
        
        if (songIndex != -1) {
          // Song exists in current playlist, just update currentIndex
          emit(current.copyWith(
            song: event.song,
            currentIndex: songIndex,
            isPlaying: true,
            position: Duration.zero,
          ));
        } else {
          // Song not in current playlist, create new playlist with single song
          emit(SongPlaying(
            song: event.song,
            isPlaying: true,
            position: Duration.zero,
            playlist: [event.song],
            currentIndex: 0,
          ));
        }
      } else {
        // Create new state with single song playlist
        emit(SongPlaying(
          song: event.song,
          isPlaying: true,
          position: Duration.zero,
          playlist: [event.song],
          currentIndex: 0,
        ));
      }

      await _playAudioFromUrl(event.song.mp3Url);
      _setupPositionListener();
    } catch (e) {
      print('Error playing audio: $e');
      emit(PlayingSongInitial());
    }
  }

  Future<void> _onPlayPlaylist(PlayPlaylistEvent event, Emitter<PlayingSongState> emit) async {
    if (event.playlist.isEmpty) return;
    
    // Validate initial index
    final initialIndex = event.initialIndex.clamp(0, event.playlist.length - 1);

    try {
      await _stopCurrentPlayback();

      final initialSong = event.playlist[initialIndex];
      
      emit(SongPlaying(
        song: initialSong,
        isPlaying: true,
        position: Duration.zero,
        playlist: event.playlist,
        currentIndex: initialIndex,
      ));

      await _playAudioFromUrl(initialSong.mp3Url);
      _setupPositionListener();
    } catch (e) {
      print('Error playing playlist: $e');
      emit(PlayingSongInitial());
    }
  }

  Future<void> _onTogglePlayPause(TogglePlayPauseEvent event, Emitter<PlayingSongState> emit) async {
    if (state is SongPlaying) {
      final current = state as SongPlaying;

      try {
        if (current.isPlaying) {
          await _audioPlayer.pause();
          emit(current.copyWith(isPlaying: false));
        } else {
          await _audioPlayer.play();
          emit(current.copyWith(isPlaying: true));
        }
      } catch (e) {
        print('Error toggling play/pause: $e');
        // Keep current state on error
      }
    }
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<PlayingSongState> emit) {
    if (state is SongPlaying) {
      final current = state as SongPlaying;

      // Only update if position is valid
      if (event.position <= current.song.duration && event.position >= Duration.zero) {
        emit(current.copyWith(position: event.position));
      }
    }
  }

  Future<void> _onNextSong(NextSongEvent event, Emitter<PlayingSongState> emit) async {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      if (current.playlist.isEmpty) return;

      final nextIndex = _getNextIndex(current);
      if (nextIndex != -1) {
        await _playTrackAtIndex(current, nextIndex, emit);
      }
    }
  }

  Future<void> _onPreviousSong(PreviousSongEvent event, Emitter<PlayingSongState> emit) async {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      if (current.playlist.isEmpty) return;

      final previousIndex = _getPreviousIndex(current);
      if (previousIndex != -1) {
        await _playTrackAtIndex(current, previousIndex, emit);
      }
    }
  }

  void _onToggleShuffle(ToggleShuffleEvent event, Emitter<PlayingSongState> emit) {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      if (current.playlist.isEmpty) return;

      final newIsShuffled = !current.isShuffled;
      List<int> newShuffledOrder = [];

      if (newIsShuffled) {
        // Create random order
        newShuffledOrder = List.generate(current.playlist.length, (index) => index);
        newShuffledOrder.shuffle(_random);
        
        // Ensure current song is first in shuffled list
        final currentIndexInShuffle = newShuffledOrder.indexOf(current.currentIndex);
        if (currentIndexInShuffle != 0) {
          newShuffledOrder.removeAt(currentIndexInShuffle);
          newShuffledOrder.insert(0, current.currentIndex);
        }
      }

      emit(current.copyWith(
        isShuffled: newIsShuffled,
        shuffledOrder: newShuffledOrder,
      ));
    }
  }

  void _onToggleRepeat(ToggleRepeatEvent event, Emitter<PlayingSongState> emit) {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      RepeatMode newMode;
      switch (current.repeatMode) {
        case RepeatMode.none:
          newMode = RepeatMode.all;
          break;
        case RepeatMode.all:
          newMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          newMode = RepeatMode.none;
          break;
      }

      emit(current.copyWith(repeatMode: newMode));
    }
  }

  Future<void> _onJumpToTrack(JumpToTrackEvent event, Emitter<PlayingSongState> emit) async {
    if (state is SongPlaying) {
      final current = state as SongPlaying;
      
      if (event.index < 0 || event.index >= current.playlist.length) return;

      await _playTrackAtIndex(current, event.index, emit);
    }
  }

  // Helper methods
  Future<void> _stopCurrentPlayback() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _audioPlayer.stop();
  }

  Future<void> _playAudioFromUrl(String url) async {
    await _audioPlayer.setUrl(url);
    await _audioPlayer.play();
  }

  Future<void> _playTrackAtIndex(SongPlaying current, int index, Emitter<PlayingSongState> emit) async {
    final targetSong = current.playlist[index];
    
    try {
      await _stopCurrentPlayback();

      emit(current.copyWith(
        song: targetSong,
        currentIndex: index,
        position: Duration.zero,
        isPlaying: true,
      ));

      await _playAudioFromUrl(targetSong.mp3Url);
      _setupPositionListener();
    } catch (e) {
      print('Error playing track at index $index: $e');
      // Revert to previous state on error
      emit(current.copyWith(isPlaying: false));
    }
  }

  int _getNextIndex(SongPlaying current) {
    if (current.playlist.isEmpty) return -1;

    if (current.isShuffled && current.shuffledOrder.isNotEmpty) {
      final currentShuffleIndex = current.shuffledOrder.indexOf(current.currentIndex);
      if (currentShuffleIndex != -1) {
        if (currentShuffleIndex < current.shuffledOrder.length - 1) {
          return current.shuffledOrder[currentShuffleIndex + 1];
        } else if (current.repeatMode == RepeatMode.all) {
          return current.shuffledOrder[0];
        }
      }
    } else {
      if (current.currentIndex < current.playlist.length - 1) {
        return current.currentIndex + 1;
      } else if (current.repeatMode == RepeatMode.all) {
        return 0;
      }
    }
    
    return -1;
  }

  int _getPreviousIndex(SongPlaying current) {
    if (current.playlist.isEmpty) return -1;

    if (current.isShuffled && current.shuffledOrder.isNotEmpty) {
      final currentShuffleIndex = current.shuffledOrder.indexOf(current.currentIndex);
      if (currentShuffleIndex != -1) {
        if (currentShuffleIndex > 0) {
          return current.shuffledOrder[currentShuffleIndex - 1];
        } else if (current.repeatMode == RepeatMode.all) {
          return current.shuffledOrder[current.shuffledOrder.length - 1];
        }
      }
    } else {
      if (current.currentIndex > 0) {
        return current.currentIndex - 1;
      } else if (current.repeatMode == RepeatMode.all) {
        return current.playlist.length - 1;
      }
    }
    
    return -1;
  }

  void _setupPositionListener() {
    _positionSubscription = _audioPlayer.positionStream.listen(
      (position) {
        add(UpdateProgressEvent(position));
      },
      onError: (e) {
        print('Position stream error: $e');
      },
    );
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _processingStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}