import 'package:flutter/material.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/track/track.dart';

class SongCardOverlay extends StatelessWidget {
  final TrackEntity song;
  final VoidCallback onTap;

  const SongCardOverlay({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Ảnh nền bài hát
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withAlpha(40),
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  song.imageUrl,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Lớp phủ gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.black.withAlpha(200),
                      Colors.black.withAlpha(0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Thông tin bài hát
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
