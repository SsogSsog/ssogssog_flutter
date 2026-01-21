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

  Future<ThemeCountResult?> getThemeDetailCounts(String themeName) async {
    try {
      final encodedTheme = Uri.encodeComponent(themeName);
      final response = await _apiClient.dio.get('/stock/themes/$encodedTheme/count');
      final apiResponse = ThemeCountResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      }
      return null;
    } catch (e) {
      print('Theme Count Error: $e');
      return null;
    }
  }

  Future<ThemeStockResult?> getThemeStockList(
      String themeName, int page, int size) async {
    try {
      final encodedTheme = Uri.encodeComponent(themeName);
      final response = await _apiClient.dio.get(
        '/stock/themes/$encodedTheme',
        queryParameters: {
          'page': page,
          'size': size,
          // 'sort': 'currentPrice,desc' // Add default sort if needed, user said 1 type only
        },
      );
      final apiResponse = ThemeStockResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      }
      return null;
    } catch (e) {
      print('Theme List Error: $e');
      return null;
    }
  }
}
