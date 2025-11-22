import 'package:get_it/get_it.dart';

import '../data/repository/album/album_repository_impl.dart';
import '../data/repository/artist/artist_repository_impl.dart';
import '../data/repository/track/track_repository_impl.dart';
import '../data/repository/search/search_repository_impl.dart';
import '../data/sources/album/album_api_service.dart';
import '../data/sources/artist/artist_api_service.dart';
import '../data/sources/track/track_api_service.dart';
import '../data/sources/search/search_api_service.dart';
import '../domain/repository/album/album_repository.dart';
import '../domain/repository/artist/artist_repository.dart';
import '../domain/repository/track/track_repository.dart';
import '../domain/repository/search/search_repository.dart';
import '../domain/usecases/album/album_use_case.dart';
import '../domain/usecases/artist/artist_use_case.dart';
import '../domain/usecases/track/track_use_case.dart';
import '../domain/usecases/search/search_use_case.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //song
  sl.registerSingleton<TrackApiService>(
      TrackApiServiceImpl()
  );
  sl.registerSingleton<TrackRepository>(
      TrackRepositoryImpl()
  );
  sl.registerSingleton<TrackUseCase>(
      TrackUseCase()
  );

  // Album
  sl.registerSingleton<AlbumApiService>(
    AlbumApiServiceImpl(),
  );
  sl.registerSingleton<AlbumRepository>(
    AlbumRepositoryImpl(),
  );
  sl.registerSingleton<AlbumUseCase>(
    AlbumUseCase(),
  );

  // Artists
  sl.registerSingleton<ArtistApiService>(
    ArtistApiServiceImpl(),
  );
  sl.registerSingleton<ArtistRepository>(
    ArtistRepositoryImpl(),
  );
  sl.registerSingleton<ArtistUseCase>(
    ArtistUseCase(),
  );

  // Search
  sl.registerSingleton<SearchApiService>(
    SearchApiServiceImpl(),
  );
  sl.registerSingleton<SearchRepository>(
    SearchRepositoryImpl(),
  );
  sl.registerSingleton<SearchUseCase>(
    SearchUseCase(),
  );
}
