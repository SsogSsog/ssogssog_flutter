import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/stock_overview_model.dart';

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
}
