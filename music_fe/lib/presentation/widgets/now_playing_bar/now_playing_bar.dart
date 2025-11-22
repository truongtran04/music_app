import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../../core/navigations/app_router.dart';
import 'bloc/now_playing_bloc.dart';
import 'bloc/now_playing_state.dart';
import 'bloc/now_playing_event.dart';

class NowPlayingBar extends StatefulWidget {
  const NowPlayingBar({super.key});

  @override
  State<NowPlayingBar> createState() => _NowPlayingBarState();
}

class _NowPlayingBarState extends State<NowPlayingBar> {
  Color backgroundColor = Colors.grey[900]!;
  String? lastImageUrl;

  @override
  void didUpdateWidget(covariant NowPlayingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Optionally: reset when widget is rebuilt
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayingSongBloc, PlayingSongState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) return true;
        if (previous is SongPlaying && current is SongPlaying) {
          return previous.song != current.song ||
              previous.isPlaying != current.isPlaying ||
              (current.position.inSeconds - previous.position.inSeconds).abs() >= 1;
        }
        return true;
      },
      builder: (context, state) {
        if (state is SongPlaying) {
          final song = state.song;

          // Nếu ảnh mới, thì gọi update màu
          if (lastImageUrl != song.imageUrl) {
            lastImageUrl = song.imageUrl;
            _updatePalette(song.imageUrl);
          }

          final percent = song.duration.inSeconds == 0
              ? 0.0
              : state.position.inSeconds / song.duration.inSeconds;

          return GestureDetector(
            onTap: () {
              AppRouter.router.navigateTo(context, '/musicPlayer');

            },
            child: Stack(
              children: [
                Container(
                  height: 76,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              song.imageUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.music_note, color: Colors.white),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  song.artistID ?? 'Unknown Artist',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.devices, color: Colors.grey[300], size: 20),
                          const SizedBox(width: 12),
                          Icon(Icons.favorite, color: Colors.green, size: 22),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              context.read<PlayingSongBloc>().add(TogglePlayPauseEvent());
                            },
                            child: Icon(
                              state.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent.clamp(0.0, 1.0),
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withAlpha(40),
                            Colors.black.withAlpha(5),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
