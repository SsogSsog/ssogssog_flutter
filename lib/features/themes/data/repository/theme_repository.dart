import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/themes/data/model/theme_models.dart';

class ThemeRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ThemeStatsResult?> getThemeStats() async {
    try {
      final response = await _apiClient.dio.get('/stock/themes/stats');

      final apiResponse = ThemeStatsResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        // Handle error logging if needed
        print('Theme API Error: ${apiResponse.message}');
        return null;
      }
    } catch (e) {
      print('Theme Network Error: $e');
      return null;
    }
  }
}
