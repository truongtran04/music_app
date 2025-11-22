import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/bloc/album/album_bloc.dart';
import 'package:music_app/presentation/bloc/album/album_state.dart';

class Propose extends StatelessWidget {
  final Function(String albumId)? onAlbumTap;
  const Propose({super.key, this.onAlbumTap});

  @override
  Widget build(BuildContext context) {
    final double albumWidth = MediaQuery.of(context).size.width * 0.35;

    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        if (state is AlbumLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AlbumLoaded) {
          final albums = state.albums;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              top: 10,
              left: 16,
              bottom: 30,
            ),
            child: Row(
              children: albums.map((album) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      if (onAlbumTap != null) {
                        onAlbumTap!(album.id);
                      }
                    },
                    child: SizedBox(
                      width: albumWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: albumWidth,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(album.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            album.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (state is AlbumError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }
        return const SizedBox.shrink();
      },
    );
  }
}