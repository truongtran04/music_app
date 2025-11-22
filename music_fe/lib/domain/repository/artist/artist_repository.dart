import 'package:dartz/dartz.dart';
import '../../entities/artist/artist.dart';

abstract class ArtistRepository {
  Future<Either<String, List<ArtistEntity>>> getAllArtists();
}