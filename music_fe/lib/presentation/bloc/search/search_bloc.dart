import 'package:bloc/bloc.dart';
import 'package:music_app/core/service_locator.dart';
import 'package:music_app/domain/usecases/search/search_use_case.dart';
import 'package:music_app/data/sources/search/search_api_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    
    // Nếu query rỗng, reset về trạng thái ban đầu
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    
    try {
      final result = await sl<SearchUseCase>().call(params: event.query);
      
      result.fold(
        (failure) => emit(SearchError(failure)),
        (searchResults) => emit(SearchLoaded(searchResults)),
      );
    } catch (e) {
      emit(SearchError('Đã xảy ra lỗi không mong muốn: ${e.toString()}'));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}