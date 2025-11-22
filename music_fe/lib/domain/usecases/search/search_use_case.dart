import 'package:dartz/dartz.dart';
import 'package:music_app/domain/repository/search/search_repository.dart';
import '../../../core/service_locator.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/sources/search/search_api_service.dart';

class SearchUseCase extends UserCase<Either<String, SearchResults>, String> {
  @override
  Future<Either<String, SearchResults>> call({String? params}) async {
    if (params == null || params.trim().isEmpty) {
      return Left('Query is null or empty');
    }
    return await sl<SearchRepository>().search(params.trim());
  }
}