import 'package:flutter/material.dart';

import '../../../../domain/entities/track/track.dart';

class SongCardBelow extends StatelessWidget {
  final TrackEntity song;
  final VoidCallback onTap;

  const SongCardBelow({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withAlpha(40),
                            offset: Offset(0, 0)
                        )
                      ]
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
                          Colors.black.withAlpha(210),
                          Colors.black.withAlpha(10),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
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
            Text(
              "${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        )
      ),
    );
  }
}
