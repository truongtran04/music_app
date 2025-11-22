import 'package:dartz/dartz.dart';
import '../../../core/service_locator.dart';
import '../../../domain/repository/search/search_repository.dart';
import '../../sources/search/search_api_service.dart';

class SearchRepositoryImpl extends SearchRepository {
  @override
  Future<Either<String, SearchResults>> search(String query) async {
    return await sl<SearchApiService>().search(query);
  }
}