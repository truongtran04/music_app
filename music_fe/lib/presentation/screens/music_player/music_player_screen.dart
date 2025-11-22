import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/music_player/body_music_player.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BodyMusicPlayer(),
    );
  }
}
