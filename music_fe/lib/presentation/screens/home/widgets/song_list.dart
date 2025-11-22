import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/presentation/bloc/track/track_bloc.dart';
import 'package:music_app/presentation/bloc/track/track_state.dart';
import 'package:music_app/presentation/screens/home/widgets/song_card_below.dart';

import '../../../widgets/now_playing_bar/bloc/now_playing_bloc.dart';
import '../../../widgets/now_playing_bar/bloc/now_playing_event.dart';
import 'song_card_overlay.dart';
import 'song_card_placeholder.dart';
import 'song_card_type.dart';


class SongList extends StatelessWidget {
  final SongCardType cardType;

  const SongList({
    super.key,
    this.cardType = SongCardType.overlay, // mặc định overlay
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SongLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
                top: 10,
                left: 16,
                bottom: 10
            ),
            child: Row(
              children: List.generate(
                state.songs.length,
                    (index) {
                  final song = state.songs[index];
                  final card = cardType == SongCardType.overlay
                      ? SongCardOverlay(song: song, onTap: () {
                    context.read<PlayingSongBloc>().add(PlaySongEvent(song));
                  })
                      : SongCardBelow(song: song, onTap: () {
                    context.read<PlayingSongBloc>().add(PlaySongEvent(song));
                  });
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: card,
                  );
                },
              ),
            ),
          );
        } else if (state is SongError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
