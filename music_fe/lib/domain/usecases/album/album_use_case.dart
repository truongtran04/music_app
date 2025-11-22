import 'package:dartz/dartz.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/entities/album/album.dart';
import 'package:music_app/domain/repository/album/album_repository.dart';

import '../../../core/service_locator.dart';
import '../../entities/track/track.dart';

class AlbumUseCase extends UserCase<Either<String, List<AlbumEntity>>, void> {
  @override
  Future<Either<String, List<AlbumEntity>>> call({void params}) async {
    return await sl<AlbumRepository>().getAllAlbums();
  }

  Future<Either<String, AlbumEntity>> getAlbumById(String id) async {
    return await sl<AlbumRepository>().getAlbumById(id);
  }

  Future<Either<String, List<TrackEntity>>> getTracksByAlbumId(String id) async {
    return await sl<AlbumRepository>().getTracksByAlbumId(id);
  }
}