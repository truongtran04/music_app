import 'package:dartz/dartz.dart';

import '../../entities/track/track.dart';

abstract class TrackRepository {
  Future<Either<String, List<TrackEntity>>> getAllTracks();
}