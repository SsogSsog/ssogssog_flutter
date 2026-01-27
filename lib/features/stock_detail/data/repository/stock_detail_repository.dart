import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/stock_overview_model.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/daily_price_model.dart';

class StockDetailRepository {
  final ApiClient _apiClient = ApiClient();

  Future<StockOverview?> getStockOverview(String stockCode) async {
    try {
      final response = await _apiClient.dio.get(
        '/stock/$stockCode/overview',
      );

      final apiResponse = StockOverviewResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        print('Stock Overview API Error: ${apiResponse.message}');
        return null;
      }
    } catch (e) {
      print('Stock Overview Exception: $e');
      return null;
    }
  }

  Future<DailyPriceResult?> getDailyPrices(String stockCode, {int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        '/stock/$stockCode/daily-prices',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      final apiResponse = DailyPriceResponse.fromJson(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        print('Daily Price API Error: ${apiResponse.message}');
        return null;
      }
    } catch (e) {
      print('Daily Price Exception: $e');
      return null;
    }
  }
}
