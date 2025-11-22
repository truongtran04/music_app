import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../now_playing_bar/bloc/now_playing_bloc.dart';
import '../now_playing_bar/bloc/now_playing_event.dart';
import 'bloc/album_detail_bloc.dart';
import 'bloc/album_detail_state.dart';

class AlbumDetailPage extends StatelessWidget {
  final VoidCallback? onBack;
  const AlbumDetailPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF44474B), Color(0xFF181818)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
          builder: (context, state) {
            if (state is AlbumDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            } else if (state is AlbumDetailLoaded) {
              final album = state.album;
              final tracks = state.tracks;

              return ListView(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight + 24,
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                children: [
                  // Album Cover
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        album.imageUrl,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 220,
                            height: 220,
                            color: Colors.grey[850],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Album Title
                  Text(
                    album.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Artist Info
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        album.artist,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Album${album.releaseDate != null ? ' • ${album.releaseDate!.year}' : ''}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Action Buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.green,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Play entire album as playlist starting from first track
                          if (tracks.isNotEmpty) {
                            context.read<PlayingSongBloc>().add(
                              PlayPlaylistEvent(
                                playlist: tracks,
                                initialIndex: 0,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Track List
                  if (tracks.isNotEmpty) ...[
                    Text(
                      'Tracks (${tracks.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tracks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final track = entry.value;
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        title: Text(
                          track.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          album.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDuration(track.duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        onTap: () {
                          // Play the selected track and set the entire album as playlist
                          context.read<PlayingSongBloc>().add(
                            PlayPlaylistEvent(
                              playlist: tracks,
                              initialIndex: index,
                            ),
                          );
                        },
                        dense: true,
                      );
                    }).toList(),
                  ] else ...[
                    const Center(
                      child: Text(
                        'No tracks available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  
                  // Album Description
                  if (album.description != null && album.description!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'About',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      album.description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              );
            } else if (state is AlbumDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading album details',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            // Show loading state initially or when no data
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }
}