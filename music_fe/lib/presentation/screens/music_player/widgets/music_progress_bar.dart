import 'package:flutter/material.dart';

class MusicProgressBar extends StatelessWidget {
  final double currentPosition;
  final double totalDuration;

  const MusicProgressBar({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
  });

  String formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              activeTrackColor: Colors.white70,
              inactiveTrackColor: Colors.grey[800],
              thumbColor: Colors.white,
            ),
            child: Slider(
              min: 0,
              max: totalDuration,
              value: currentPosition.clamp(0.0, totalDuration),
              onChanged: (_) {}, // TODO: Add seek event here if needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(currentPosition),
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white60),
                ),
                Text(
                  formatDuration(totalDuration),
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
