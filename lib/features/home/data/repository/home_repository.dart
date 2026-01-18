import 'package:dio/dio.dart';
import 'package:ssogssog_flutter/core/network/api_client.dart';
import 'package:ssogssog_flutter/features/home/data/model/home_ranking_models.dart';

class HomeRepository {
  final ApiClient _apiClient = ApiClient();

  /// 급상승 TOP 5 조회
  Future<List<StockRankingItem>> getRisingStocks() async {
    try {
      final response = await _apiClient.dio.get('/stock/rising');
      
      final apiResponse = ApiResponse<StockRankingResult>.fromJson(
        response.data,
        (json) => StockRankingResult.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.result?.items ?? [];
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환 (또는 rethrow)
      print('Error fetching rising stocks: $e');
      return [];
    }
  }

  /// 급하락 TOP 5 조회
  Future<List<StockRankingItem>> getFallingStocks() async {
    try {
      final response = await _apiClient.dio.get('/stock/falling');
      
      final apiResponse = ApiResponse<StockRankingResult>.fromJson(
        response.data,
        (json) => StockRankingResult.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.result?.items ?? [];
    } catch (e) {
      print('Error fetching falling stocks: $e');
      return [];
    }
  }

  /// 거래량 TOP 5 조회
  Future<List<StockRankingItem>> getVolumeStocks() async {
    try {
      final response = await _apiClient.dio.get('/stock/volume');
      
      final apiResponse = ApiResponse<StockRankingResult>.fromJson(
        response.data,
        (json) => StockRankingResult.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.result?.items ?? [];
    } catch (e) {
      print('Error fetching volume stocks: $e');
      return [];
    }
  }
}
