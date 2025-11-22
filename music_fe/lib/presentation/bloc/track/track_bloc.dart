import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/domain/usecases/track/track_use_case.dart';
import 'track_event.dart';
import 'track_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final TrackUseCase getAllSongs;

  SongBloc({required this.getAllSongs}) : super(SongInitial()) {
    on<FetchAllSongsEvent>((event, emit) async {
      emit(SongLoading());

      final result = await getAllSongs();

      result.fold(
            (failure) => emit(SongError(failure)),
            (songs) => emit(SongLoaded(songs)),
      );
    });
  }
}
