import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/data/sources/api_constants.dart';

import '../../models/track/track.dart';

abstract class TrackApiService {
  Future<Either<String, List<TrackModel>>> fetchTracks();
}

class TrackApiServiceImpl extends TrackApiService {
  @override
  Future<Either<String, List<TrackModel>>> fetchTracks() async {
    try {

      final response = await http.get(Uri.parse(ApiConstants.getAllTracks));

      if (response.statusCode == 200) {

        final jsonResponse = jsonDecode(response.body);

        // Kiểm tra success flag
        if (jsonResponse['success'] == true) {

          final jsonList = jsonResponse['data'] as List;

          final songs = jsonList.map((e) => TrackModel.fromJson(e)).toList();

          return Right(songs);

        } else {
          return Left(jsonResponse['message'] ?? "Unknown error");
        }
      } else {
        return Left("Failed with code: ${response.statusCode}");
      }
    } catch (e) {
      return Left("Exception: $e");
    }
  }
}