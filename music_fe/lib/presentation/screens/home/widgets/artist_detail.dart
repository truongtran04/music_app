import 'package:flutter/material.dart';

class ArtistDetailPage extends StatelessWidget {
  final VoidCallback? onBack;
  const ArtistDetailPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final artist = {
      'name': 'Michael Jackson',
      'image':
          'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
      'monthlyListeners': '34,694,882',
      'popular': [
        {
          'title': 'Thriller',
          'cover':
              'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
          'plays': '1,285,913,284'
        },
        {
          'title': 'XSCAPE',
          'cover':
              'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
          'plays': '94,006,232'
        },
        {
          'title': 'Bad 25th Anniversary',
          'cover':
              'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
          'plays': '815,544,961'
        },
        {
          'title': 'Thriller 25 Super Deluxe Edition',
          'cover':
              'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
          'plays': '518,903,916'
        },
        {
          'title': 'Michael Jackson A Capella',
          'cover':
              'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
          'plays': '340,982,544'
        },
      ],
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Banner
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(artist['image'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 24,
                  child: Text(
                    artist['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Bên trái: listeners + nút
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${artist['monthlyListeners']} monthly listeners',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white, width: 1.5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Following',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.more_horiz, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Nút play lớn bên phải
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(18),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 0.7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ...List.generate((artist['popular'] as List).length, (i) {
              final song = (artist['popular'] as List)[i] as Map<String, dynamic>;
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        song['cover'] as String,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  song['title'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  song['plays'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                dense: true,
                horizontalTitleGap: 12,
                visualDensity: VisualDensity.compact,
              );
            }),
            const SizedBox(height: 24),
            // Bạn có thể thêm phần "Artist Pick" hoặc các section khác ở đây
          ],
        ),
      ),
    );
  }
}