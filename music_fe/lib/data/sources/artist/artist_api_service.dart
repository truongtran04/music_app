import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../models/artist/artist.dart';
import '../api_constants.dart';

abstract class ArtistApiService {
  Future<Either<String, List<ArtistModel>>> fetchArtists();
}

class ArtistApiServiceImpl extends ArtistApiService {
  @override
  Future<Either<String, List<ArtistModel>>> fetchArtists() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllArtists));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          final artists = jsonResponse
              .map<ArtistModel>(
                (e) => ArtistModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return Right(artists);
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