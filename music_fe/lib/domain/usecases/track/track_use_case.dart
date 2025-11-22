import 'package:dartz/dartz.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/entities/track/track.dart';

import '../../../core/service_locator.dart';
import '../../repository/track/track_repository.dart';

class TrackUseCase extends UserCase<Either<String, List<TrackEntity>>, void> {

  @override
  Future<Either<String, List<TrackEntity>>> call({void params}) async {
    return await sl<TrackRepository>().getAllTracks();
  }
}