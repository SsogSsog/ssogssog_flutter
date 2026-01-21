import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/search/data/model/search_models.dart';

class SearchRepository {
  final ApiClient _apiClient = ApiClient();

  // Autocomplete Search (Intermediate)
  Future<List<SearchStockItem>> getAutocomplete(String keyword, {int limit = 5}) async {
    try {
      final response = await _apiClient.dio.get(
        '/stock/search/autocomplete',
        queryParameters: {
          'keyword': keyword,
          'limit': limit,
        },
      );
      final apiResponse = AutocompleteResponse.fromJson(response.data);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      }
      return [];
    } catch (e) {
      print('Autocomplete Error: $e');
      return [];
    }
  }

  // Full Search (Paginated)
  Future<SearchResultContent?> searchStocks(String keyword, int page, int size) async {
    try {
      final response = await _apiClient.dio.get(
        '/stock/search',
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'size': size,
          // 'sort': 'currentPrice,desc' // Add default sort if needed, current API default seems fine
        },
      );
      final apiResponse = SearchResponse.fromJson(response.data);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      }
      return null;
    } catch (e) {
      print('Search Error: $e');
      return null;
    }
  }
}
