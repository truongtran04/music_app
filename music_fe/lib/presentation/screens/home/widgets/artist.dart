import 'package:flutter/material.dart';
import 'artist_detail.dart';

// Định nghĩa class Artist mẫu để sử dụng dữ liệu giả
class Artist {
  final String imageUrl;
  final String name;

  const Artist({required this.imageUrl, required this.name});
}

class ArtistList extends StatelessWidget {
  final VoidCallback? onArtistTap;
  const ArtistList({super.key, this.onArtistTap});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final sampleArtists = const [
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
        name: 'Wxrdie',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174d11431a2d0efb06cf912d920',
        name: 'BigDaddy',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
        name: 'Wxrdie',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174d11431a2d0efb06cf912d920',
        name: 'BigDaddy',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
        name: 'Wxrdie',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174d11431a2d0efb06cf912d920',
        name: 'BigDaddy',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174f7ac790a43867c10ef8a7d29',
        name: 'Wxrdie',
      ),
      Artist(
        imageUrl: 'https://i.scdn.co/image/ab67616100005174d11431a2d0efb06cf912d920',
        name: 'BigDaddy',
      ),
    ];

    final double avatarSize = MediaQuery.of(context).size.width * 0.28;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 30),
      child: Row(
        children: sampleArtists.map((artist) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                if (onArtistTap != null) {
                  onArtistTap!();
                }
              },
              child: SizedBox(
                width: avatarSize,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: avatarSize,
                      width: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[850],
                        image: DecorationImage(
                          image: NetworkImage(artist.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      artist.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}