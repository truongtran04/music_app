import 'package:dartz/dartz.dart';
import '../../../domain/entities/album/album.dart';
import '../../../domain/entities/track/track.dart';
import '../../../domain/repository/album/album_repository.dart';
import '../../sources/album/album_api_service.dart';
import '../../../core/service_locator.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  @override
  Future<Either<String, List<AlbumEntity>>> getAllAlbums() async {
    return await sl<AlbumApiService>().fetchAlbums();
  }

  @override
  Future<Either<String, AlbumEntity>> getAlbumById(String id) async {
    return await sl<AlbumApiService>().getAlbumById(id);
  }

  @override
  Future<Either<String, List<TrackEntity>>> getTracksByAlbumId(String id) async {
    return await sl<AlbumApiService>().getTracksByAlbumId(id);
  }
}