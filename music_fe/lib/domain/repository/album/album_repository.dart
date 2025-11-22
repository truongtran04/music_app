import 'package:dartz/dartz.dart';
import 'package:music_app/domain/entities/track/track.dart';
import '../../entities/album/album.dart';

abstract class AlbumRepository {
  Future<Either<String, List<AlbumEntity>>> getAllAlbums();
  Future<Either<String, AlbumEntity>> getAlbumById(String id);
  Future<Either<String, List<TrackEntity>>> getTracksByAlbumId(String id);
}