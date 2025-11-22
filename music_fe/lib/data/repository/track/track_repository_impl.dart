import 'package:dartz/dartz.dart';

import '../../../core/service_locator.dart';
import '../../../domain/entities/track/track.dart';
import '../../../domain/repository/track/track_repository.dart';
import '../../sources/track/track_api_service.dart';

class TrackRepositoryImpl extends TrackRepository {
  @override
  Future<Either<String, List<TrackEntity>>> getAllTracks() async {
    return await sl<TrackApiService>().fetchTracks();
  }
}