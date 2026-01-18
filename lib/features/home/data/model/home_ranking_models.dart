/// 공통 API 응답 래퍼
class ApiResponse<T> {
  final bool isSuccess;
  final String code;
  final String message;
  final T? result;

  ApiResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      isSuccess: json['isSuccess'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      result: json['result'] == null ? null : fromJsonT(json['result']),
    );
  }
}

/// 랭킹 API 결과 (items 리스트 포함)
class StockRankingResult {
  final List<StockRankingItem> items;
  final int totalCount;

  StockRankingResult({
    required this.items,
    required this.totalCount,
  });

  factory StockRankingResult.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return StockRankingResult(
      items: list.map((e) => StockRankingItem.fromJson(e)).toList(),
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

/// 개별 종목 랭킹 아이템
class StockRankingItem {
  final int rank;
  final String stockCode;
  final String corpName;
  final int currentPrice;
  final double changeRate;
  final int tradingVolume;

  StockRankingItem({
    required this.rank,
    required this.stockCode,
    required this.corpName,
    required this.currentPrice,
    required this.changeRate,
    required this.tradingVolume,
  });

  factory StockRankingItem.fromJson(Map<String, dynamic> json) {
    return StockRankingItem(
      rank: json['rank'] as int? ?? 0,
      stockCode: json['stockCode'] as String? ?? '',
      corpName: json['corpName'] as String? ?? '',
      currentPrice: json['currentPrice'] as int? ?? 0,
      // API may return int or double for changeRate
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
      tradingVolume: json['tradingVolume'] as int? ?? 0,
    );
  }
}
