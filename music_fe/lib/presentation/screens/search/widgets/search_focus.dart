import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/presentation/bloc/search/search_bloc.dart';
import 'package:music_app/presentation/bloc/search/search_event.dart';
import 'package:music_app/presentation/bloc/search/search_state.dart';
import 'package:music_app/presentation/screens/search/widgets/search_appbar.dart';
import 'package:music_app/presentation/screens/search/widgets/search_result.dart';
import 'dart:async';

import '../../../widgets/now_playing_bar/bloc/now_playing_bloc.dart';
import '../../../widgets/now_playing_bar/bloc/now_playing_event.dart';

class SearchFocusPage extends StatefulWidget {
  final Function(String albumId)? onAlbumTap;
  
  const SearchFocusPage({super.key, this.onAlbumTap});

  @override
  State<SearchFocusPage> createState() => _SearchFocusPageState();
}

class _SearchFocusPageState extends State<SearchFocusPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Focus vào search box khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    // Debounce search để tránh call API quá nhiều
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(value.trim()));
      } else {
        context.read<SearchBloc>().add(SearchCleared());
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchBloc>().add(SearchCleared());
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: SearchAppBar(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onChanged,
        onClear: _clearSearch,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          }
          
          if (state is SearchLoaded) {
            final results = state.results;
            final hasResults = results.songs.isNotEmpty || 
                              results.albums.isNotEmpty || 
                              results.artists.isNotEmpty;
            
            if (!hasResults) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không tìm thấy kết quả',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy thử từ khóa khác',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị bài hát
                  if (results.songs.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Bài hát', 
                      count: results.songs.length,
                      isDark: isDark,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.songs.length,
                      itemBuilder: (context, index) {
                        final track = results.songs[index];
                        return TrackItem(
                          track: track,
                          onTap: () {
                            // Phát bài hát khi được bấm
                            context.read<PlayingSongBloc>().add(PlaySongEvent(track));
                          },
                        );
                      },
                    ),
                  ],

                  // Hiển thị album
                  if (results.albums.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Album', 
                      count: results.albums.length,
                      isDark: isDark,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.albums.length,
                      itemBuilder: (context, index) {
                        final album = results.albums[index];
                        return AlbumItem(
                          album: album,
                          onTap: () {
                            // Navigate to album detail page
                            if (widget.onAlbumTap != null) {
                              widget.onAlbumTap!(album.id);
                            }
                          },
                        );
                      },
                    ),
                  ],

                  // Hiển thị nghệ sĩ
                  if (results.artists.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Nghệ sĩ', 
                      count: results.artists.length,
                      isDark: isDark,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.artists.length,
                      itemBuilder: (context, index) {
                        final artist = results.artists[index];
                        return ArtistItem(
                          artist: artist,
                          onTap: () {
                            // Xử lý mở trang nghệ sĩ
                            print('Open artist: ${artist.name}');
                            // TODO: Navigate to artist detail page
                          },
                        );
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 0), // Bottom padding for better UX
                ],
              ),
            );
          }
          
          if (state is SearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Có lỗi xảy ra',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<SearchBloc>().add(
                          SearchQueryChanged(_controller.text.trim())
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          
          // State ban đầu
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Phát nội dung bạn thích',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tìm kiếm nghệ sĩ, bài hát, album và nhiều nội dung khác.',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}