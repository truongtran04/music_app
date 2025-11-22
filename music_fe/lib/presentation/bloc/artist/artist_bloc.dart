import 'package:bloc/bloc.dart';
import 'package:music_app/core/service_locator.dart';
import 'package:music_app/domain/usecases/artist/artist_use_case.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  ArtistBloc() : super(ArtistInitial()) {
    on<FetchArtists>(_onFetchArtists);
  }

  Future<void> _onFetchArtists(FetchArtists event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final result = await sl<ArtistUseCase>().call();
    emit(
      result.fold(
        (failure) => ArtistError(failure.toString()),
        (artists) => ArtistLoaded(artists),
      ),
    );
  }
}