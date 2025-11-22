import 'package:bloc/bloc.dart';
import 'package:music_app/core/service_locator.dart';
import 'package:music_app/domain/usecases/album/album_use_case.dart';
import 'album_detail_event.dart';
import 'album_detail_state.dart';

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  AlbumDetailBloc() : super(AlbumDetailInitial()) {
    on<FetchAlbumDetail>(_onFetchAlbumDetail);
  }

  Future<void> _onFetchAlbumDetail(
    FetchAlbumDetail event,
    Emitter<AlbumDetailState> emit,
  ) async {
    emit(AlbumDetailLoading());

    try {
      // Fetch album details
      final albumResult = await sl<AlbumUseCase>().getAlbumById(event.albumId);
      
      // Fetch tracks for this album
      final tracksResult = await sl<AlbumUseCase>().getTracksByAlbumId(event.albumId);

      // Check if both requests are successful
      albumResult.fold(
        (failure) => emit(AlbumDetailError(failure)),
        (album) {
          tracksResult.fold(
            (failure) => emit(AlbumDetailError(failure)),
            (tracks) => emit(AlbumDetailLoaded(album: album, tracks: tracks)),
          );
        },
      );
    } catch (e) {
      emit(AlbumDetailError(e.toString()));
    }
  }
}