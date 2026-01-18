import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';
import 'package:ssogssog_flutter/features/vault/data/model/strategy_models.dart';

class StrategyRepository {
  final ApiClient _apiClient = ApiClient();

  /// 투자 전략 저장
  /// [request] : 저장할 필터 조건들
  /// Return: 성공 시 true, 실패 시 false (간단한 처리)
  Future<bool> saveStrategy(ScreenerRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/members/strategies',
        data: request.toJson(),
      );
      
      // 200~299 사이면 성공으로 간주
      if (response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        return true;
      }
      return false;
    } catch (e) {
      print('Strategy Save Error: $e');
      return false;
    }
  }

  /// 투자 전략 목록 조회
  Future<List<Strategy>> getStrategies() async {
    try {
      final response = await _apiClient.dio.get('/members/strategies');
      
      if (response.statusCode == 200 && response.data != null) {
        final strategyResponse = StrategyResponse.fromJson(response.data);
        if (strategyResponse.isSuccess && strategyResponse.result != null) {
          return strategyResponse.result!.strategies;
        }
      }
      return [];
    } catch (e) {
      print('Strategy Fetch Error: $e');
      return [];
    }
  }
}
