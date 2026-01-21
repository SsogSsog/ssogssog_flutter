/// 주가 범위 (Enum)
enum StockPriceRange {
  BELOW_1000,            // 1,000 미만
  FROM_1000_TO_5000,     // 1,000 ~ 5,000
  FROM_5000_TO_10000,    // 5,000 ~ 10,000
  FROM_10000_TO_30000,   // 10,000 ~ 30,000
  FROM_30000_TO_100000,  // 30,000 ~ 100,000
  ABOVE_100000;           // 100,000 이상

  String get toJson => name;
}

/// 시가총액 (Enum)
enum MarketCapBucket {
  SMALL_CAP,   // < 5,000억
  MID_CAP,     // 5,000억 ~ 3조
  LARGE_CAP;    // >= 3조

  String get toJson => name;
}

/// 성장성 지표 기준 기간 (Enum)
enum MetricBasePeriod {
  PREV_YEAR,    // 연간 (전년 동기 대비)
  PREV_QUARTER; // 분기 (전분기 동기 대비)

  String get toJson => name;
}

/// 범위 조건 DTO (min, max)
class RangeCondition {
  final double? min;
  final double? max;

  RangeCondition({this.min, this.max});

  Map<String, dynamic> toJson() {
    return {
      if (min != null) 'min': min,
      if (max != null) 'max': max,
    };
  }
}

/// 성장성 조건 DTO (min, max, period)
class GrowthCondition {
  final double? min;
  final double? max;
  final MetricBasePeriod basePeriod;

  GrowthCondition({
    this.min, 
    this.max, 
    this.basePeriod = MetricBasePeriod.PREV_YEAR,
  });

  Map<String, dynamic> toJson() {
    return {
      if (min != null) 'min': min,
      if (max != null) 'max': max,
      'basePeriod': basePeriod.toJson,
    };
  }
}

/// 스크리너 요청 DTO
class ScreenerRequest {
  final StockPriceRange? stockPriceRange;
  final MarketCapBucket? marketCapBucket;
  
  final RangeCondition? per;
  final RangeCondition? roe;
  final RangeCondition? debtRatio;
  final RangeCondition? operatingProfitRatio;
  final RangeCondition? dividendYieldRatio;
  final RangeCondition? foreignOwnershipRate;
  
  final GrowthCondition? salesGrowthRatio;
  final GrowthCondition? netProfitGrowthRatio;

  ScreenerRequest({
    this.stockPriceRange,
    this.marketCapBucket,
    this.per,
    this.roe,
    this.debtRatio,
    this.operatingProfitRatio,
    this.dividendYieldRatio,
    this.foreignOwnershipRate,
    this.salesGrowthRatio,
    this.netProfitGrowthRatio,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (stockPriceRange != null) data['stockPriceRange'] = stockPriceRange!.toJson;
    if (marketCapBucket != null) data['marketCapBucket'] = marketCapBucket!.toJson;
    
    if (per != null) data['per'] = per!.toJson();
    if (roe != null) data['roe'] = roe!.toJson();
    if (debtRatio != null) data['debtRatio'] = debtRatio!.toJson();
    if (operatingProfitRatio != null) data['operatingProfitRatio'] = operatingProfitRatio!.toJson();
    if (dividendYieldRatio != null) data['dividendYieldRatio'] = dividendYieldRatio!.toJson();
    if (foreignOwnershipRate != null) data['foreignOwnershipRate'] = foreignOwnershipRate!.toJson();
    
    if (salesGrowthRatio != null) data['salesGrowthRatio'] = salesGrowthRatio!.toJson();
    if (netProfitGrowthRatio != null) data['netProfitGrowthRatio'] = netProfitGrowthRatio!.toJson();

    return data;
  }
}

// --- Response DTOs ---

class ScreenerItem {
  final int stockId;
  final String stockCode;
  final String corpName;
  final int closePrice; // Replaced currentPrice
  final int volume;     // Restored
  final double changeRate; // Restored

  ScreenerItem({
    required this.stockId,
    required this.stockCode,
    required this.corpName,
    required this.closePrice,
    required this.volume,
    required this.changeRate,
  });

  factory ScreenerItem.fromJson(Map<String, dynamic> json) {
    return ScreenerItem(
      stockId: json['stockId'] as int? ?? 0,
      stockCode: json['stockCode'] as String? ?? '',
      corpName: json['corpName'] as String? ?? '',
      closePrice: json['closePrice'] as int? ?? 0,
      volume: json['volume'] as int? ?? 0,
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ScreenerResult {
  final List<ScreenerItem> content;
  final int currentPage;
  final int size;
  final bool hasNext;
  final int totalContentCount; // Added

  ScreenerResult({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
    required this.totalContentCount,
  });

  factory ScreenerResult.fromJson(Map<String, dynamic> json) {
    return ScreenerResult(
      content: (json['content'] as List?)
              ?.map((e) => ScreenerItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      totalContentCount: json['totalContentCount'] as int? ?? 0,
    );
  }
}

class ScreenerResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final ScreenerResult? result;

  ScreenerResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    this.result,
  });

  factory ScreenerResponse.fromJson(Map<String, dynamic> json) {
    return ScreenerResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      result: json['result'] == null ? null : ScreenerResult.fromJson(json['result']),
    );
  }
}

