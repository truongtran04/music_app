import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../models/album/album.dart';
import '../../models/track/track.dart';
import '../api_constants.dart';

abstract class AlbumApiService {
  Future<Either<String, List<AlbumModel>>> fetchAlbums();
  Future<Either<String, AlbumModel>> getAlbumById(String id);

  getTracksByAlbumId(String id) {}
}

class AlbumApiServiceImpl extends AlbumApiService {
  @override
  Future<Either<String, List<AlbumModel>>> fetchAlbums() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllAlbums));
      print('API status: ${response.statusCode}');               // in status code
      print('Raw body: ${response.body}');                      // in JSON thô
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          final albums = jsonResponse
              .map<AlbumModel>(
                (e) => AlbumModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return Right(albums);
        } else {
          return Left("Invalid response format");
        }
      } else {
        return Left("Failed with code: ${response.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
  
  @override
  Future<Either<String, AlbumModel>> getAlbumById(String id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.getAlbumById}$id'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic>) {
          final album = AlbumModel.fromJson(jsonResponse);
          return Right(album);
        } else {
          return Left("Invalid response format");
        }
      } else {
        return Left("Failed with code: ${response.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
  
  @override
  Future<Either<String, List<TrackModel>>> getTracksByAlbumId(String id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.getTracksByAlbumId}$id'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          final tracks = jsonResponse
              .map<TrackModel>(
                (e) => TrackModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return Right(tracks);
        } else {
          return Left("Invalid response format");
        }
      } else {
        return Left("Failed with code: ${response.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}