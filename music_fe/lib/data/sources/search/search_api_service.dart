// Thêm file này vào data/sources/search/search_api_service.dart

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/data/models/album/album.dart';
import 'package:music_app/data/models/artist/artist.dart';
import '../../models/track/track.dart';
import '../api_constants.dart';

// Tạo class để chứa kết quả tìm kiếm
class SearchResults {
  final List<TrackModel> songs;
  final List<AlbumModel> albums;
  final List<ArtistModel> artists;

  SearchResults({
    required this.songs,
    required this.albums,
    required this.artists,
  });

  // Chuyển đổi sang JSON để debug
  Map<String, dynamic> toJson() {
    return {
      'songs': songs.map((track) => {
        'id': track.id,
        'title': track.title,
        'artists': track.artistID,
        'imageUrl': track.imageUrl,
      }).toList(),
      'albums': albums.map((album) => {
        'id': album.id,
        'name': album.name,
        'artists': album.artist,
        'imageUrl': album.imageUrl,
      }).toList(),
      'artists': artists.map((artist) => {
        'id': artist.id,
        'name': artist.name,
        'imageUrl': artist.imageUrl,
      }).toList(),
    };
  }
}

abstract class SearchApiService {
  Future<Either<String, SearchResults>> search(String query);
}

class SearchApiServiceImpl extends SearchApiService {
  @override
  Future<Either<String, SearchResults>> search(String query) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.search}?q=${query}'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final tracks = (data['songs'] as List? ?? [])
            .map((item) => TrackModel(
                  id: item['_id'] ?? '',
                  title: item['title'] ?? '',
                  artist: item['artists'] ?? '',
                  album: item['albumID'] ?? '',
                  duration: Duration(milliseconds: item['duration'] is int ? item['duration'] : int.tryParse(item['duration'].toString()) ?? 0),
                  releaseDate: item['releaseDate'] != null
                      ? DateTime.tryParse(item['releaseDate']) ?? DateTime.now()
                      : DateTime.now(),
                  imageUrl: item['imageUrl'] ?? '',
                  mp3Url: item['mp3Url'] ?? '',
                ))
            .toList();

        final albums = (data['albums'] as List? ?? [])
            .map((item) => AlbumModel(
                  id: item['_id'] ?? '',
                  name: item['name'] ?? '',
                  imageUrl: item['coverImageUrl'] ?? '',
                  artist: item['artist'] ?? '',
                  releaseDate: item['releaseDate'] != null
                      ? DateTime.tryParse(item['releaseDate']) ?? null
                      : null,
                  description: item['description'],
                ))
            .toList();

        final artists = (data['artists'] as List? ?? [])
            .map((item) => ArtistModel(
                  id: item['_id'] ?? '',
                  name: item['name'] ?? '',
                  imageUrl: item['imageUrl'] ?? '',
                  bio: item['bio'],
                  genres: (item['genres'] as List?)?.map((e) => e.toString()).toList(),
                ))
            .toList();

        final searchResults = SearchResults(
          songs: tracks,
          albums: albums,
          artists: artists,
        );

        // In kết quả theo format mong muốn
        print('Search Results: ${jsonEncode(searchResults.toJson())}');
        
        return Right(searchResults);
      } else {
        return Left('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }
}