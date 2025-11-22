import 'package:dartz/dartz.dart';
import '../../../domain/entities/artist/artist.dart';
import '../../../domain/repository/artist/artist_repository.dart';
import '../../sources/artist/artist_api_service.dart';
import '../../../core/service_locator.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  @override
  Future<Either<String, List<ArtistEntity>>> getAllArtists() async {
    return await sl<ArtistApiService>().fetchArtists();
  }
}