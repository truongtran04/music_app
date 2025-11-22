import 'package:dartz/dartz.dart';

import '../../../data/sources/search/search_api_service.dart';

abstract class SearchRepository {
  Future<Either<String, SearchResults>> search(String query);
}