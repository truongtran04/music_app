import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:music_app/core/service_locator.dart';
import 'package:music_app/domain/usecases/album/album_use_case.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc() : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final result = await sl<AlbumUseCase>().call();
    emit(
      result.fold(
        (failure) => AlbumError(failure.toString()), // Đảm bảo truyền String
        (albums) => AlbumLoaded(albums),
      ),
    );
  }
}