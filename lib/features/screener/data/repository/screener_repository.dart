import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';

class ScreenerRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ScreenerResult?> getScreenerResults({
    required ScreenerRequest request,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/stock-metric/screener', // Updated URL
        queryParameters: {
          'page': page,
          'size': size,
          'sort': 'currentPrice,desc', // Default sort as requested
        },
        data: request.toJson(),
      );

      final apiResponse = ScreenerResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        // Handle API error logic if needed (e.g. log code/message)
        print('Screener API Error: ${apiResponse.message}');
        return null;
      }
    } catch (e) {
      print('Screener Network Error: $e');
      return null;
    }
  }
}
