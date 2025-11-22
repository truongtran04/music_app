import 'dart:math';
import 'package:flutter/material.dart';

class Genre {
  final String name;
  final String imageUrl;

  const Genre({required this.name, required this.imageUrl});
}

class Genres extends StatelessWidget {
  const Genres({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final sampleGenres = const [
      Genre(
        name: 'Pop',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Indie',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Rock',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Hip-Hop',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Jazz',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'EDM',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Pop',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Indie',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Rock',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Hip-Hop',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Jazz',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'EDM',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Pop',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
      Genre(
        name: 'Indie',
        imageUrl: 'https://i.scdn.co/image/ab67616d00001e0264eefeaaf062b7fdf9f7e6a0',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 11,
          childAspectRatio: 16 / 9,
        ),
        itemCount: sampleGenres.length,
        itemBuilder: (_, index) {
          final genre = sampleGenres[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  right: -10,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: 15 * pi / 180,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(genre.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 20,
                  child: Text(
                    genre.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}