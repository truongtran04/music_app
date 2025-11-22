import 'package:dartz/dartz.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/entities/artist/artist.dart';
import 'package:music_app/domain/repository/artist/artist_repository.dart';
import '../../../core/service_locator.dart';

class ArtistUseCase extends UserCase<Either<String, List<ArtistEntity>>, void> {
  @override
  Future<Either<String, List<ArtistEntity>>> call({void params}) async {
    return await sl<ArtistRepository>().getAllArtists();
  }
}