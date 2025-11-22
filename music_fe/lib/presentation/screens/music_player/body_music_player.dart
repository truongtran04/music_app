import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../core/navigations/app_router.dart';
import '../../widgets/now_playing_bar/bloc/now_playing_bloc.dart';
import '../../widgets/now_playing_bar/bloc/now_playing_event.dart';
import '../../widgets/now_playing_bar/bloc/now_playing_state.dart';
import 'widgets/music_progress_bar.dart';

class BodyMusicPlayer extends StatefulWidget {
  const BodyMusicPlayer({super.key});

  @override
  State<BodyMusicPlayer> createState() => _BodyMusicPlayerState();
}

class _BodyMusicPlayerState extends State<BodyMusicPlayer> {
  Color backgroundColor = Colors.grey[900]!;
  String? lastImageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<PlayingSongBloc>().state;
    if (state is SongPlaying) {
      _handleNewImage(state.song.imageUrl);
    }
  }

  void _handleNewImage(String imageUrl) {
    if (lastImageUrl != imageUrl) {
      lastImageUrl = imageUrl;
      _updatePalette(imageUrl);
    }
  }

  Future<void> _updatePalette(String imageUrl) async {
    try {
      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        maximumColorCount: 10,
      );

      final dominantColor = palette.dominantColor?.color ?? Colors.grey[900]!;

      if (mounted) {
        setState(() {
          backgroundColor = dominantColor;
        });
      }
    } catch (e) {
      print("Failed to load palette: $e");
    }
  }

  Icon _getShuffleIcon(bool? isShuffled) {
    return Icon(
      Icons.shuffle_rounded,
      color: (isShuffled ?? false) ? Colors.green : Colors.white,
    );
  }

  Icon _getRepeatIcon(RepeatMode? repeatMode) {
    switch (repeatMode ?? RepeatMode.none) {
      case RepeatMode.none:
        return const Icon(Icons.repeat_rounded, color: Colors.white);
      case RepeatMode.all:
        return const Icon(Icons.repeat_rounded, color: Colors.green);
      case RepeatMode.one:
        return const Icon(Icons.repeat_one_rounded, color: Colors.green);
    }
  }

  Icon _getPlayPauseIcon(bool isPlaying) {
    return Icon(
      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlayingSongBloc>().state;

    if (state is! SongPlaying) {
      return const Center(
        child: Text("Không có bài hát nào đang phát", style: TextStyle(color: Colors.white)),
      );
    }

    final song = state.song;
    _handleNewImage(song.imageUrl);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: backgroundColor,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        AppRouter.router.navigateTo(context, '/rootApp');
                      },
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      iconSize: 30,
                      padding: EdgeInsets.zero,
                    ),

                    const SizedBox(width: 8),

                    // Title column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "ĐANG PHÁT TỪ DANH SÁCH PHÁT",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            "Tên danh sách phát",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action (more)
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 30,
                  right: 30,
                  bottom: 90,
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      song.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          width: 300,
                          color: Colors.grey,
                          child: const Icon(Icons.music_note, size: 60, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            song.artistID ?? 'Unknown Artist',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              MusicProgressBar(
                currentPosition: state.position.inSeconds.toDouble(),
                totalDuration: song.duration.inSeconds.toDouble(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Shuffle button
                    IconButton(
                      onPressed: () {
                        context.read<PlayingSongBloc>().add(ToggleShuffleEvent());
                      },
                      icon: _getShuffleIcon(state.isShuffled),
                      iconSize: 35,
                    ),
                    // Previous button
                    IconButton(
                      onPressed: (state.hasPrevious ?? false) ? () {
                        context.read<PlayingSongBloc>().add(PreviousSongEvent());
                      } : null,
                      icon: Icon(
                        Icons.skip_previous_rounded, 
                        color: (state.hasPrevious ?? false) ? Colors.white : Colors.white38,
                      ),
                      iconSize: 45,
                    ),
                    // Play/Pause button
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<PlayingSongBloc>().add(TogglePlayPauseEvent());
                        },
                        icon: _getPlayPauseIcon(state.isPlaying),
                        iconSize: 40,
                      ),
                    ),
                    // Next button
                    IconButton(
                      onPressed: (state.hasNext ?? false) ? () {
                        context.read<PlayingSongBloc>().add(NextSongEvent());
                      } : null,
                      icon: Icon(
                        Icons.skip_next_rounded, 
                        color: (state.hasNext ?? false) ? Colors.white : Colors.white38,
                      ),
                      iconSize: 45,
                    ),
                    // Repeat button
                    IconButton(
                      onPressed: () {
                        context.read<PlayingSongBloc>().add(ToggleRepeatEvent());
                      },
                      icon: _getRepeatIcon(state.repeatMode),
                      iconSize: 35,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}