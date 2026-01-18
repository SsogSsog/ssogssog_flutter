import 'package:ssogssog_flutter/features/screener/data/model/screener_models.dart';

class Strategy {
  final int strategyId;
  final String strategyName;
  final StockPriceRange? stockPriceRange;
  final MarketCapBucket? marketCapBucket;
  
  final RangeCondition? per;
  final RangeCondition? roe;
  final RangeCondition? debtRatio;
  final RangeCondition? operatingProfitMargin; // API field: operatingProfitMargin
  final RangeCondition? netProfitMargin; // API field: netProfitMargin
  final RangeCondition? dividendYield;
  final RangeCondition? foreignOwnershipRate;

  // Growth fields are split in response
  final RangeCondition? salesGrowthQoQ;
  final RangeCondition? salesGrowthYoY;
  final RangeCondition? netProfitGrowthQoQ;
  final RangeCondition? netProfitGrowthYoY;

  Strategy({
    required this.strategyId,
    required this.strategyName,
    this.stockPriceRange,
    this.marketCapBucket,
    this.per,
    this.roe,
    this.debtRatio,
    this.operatingProfitMargin,
    this.netProfitMargin,
    this.dividendYield,
    this.foreignOwnershipRate,
    this.salesGrowthQoQ,
    this.salesGrowthYoY,
    this.netProfitGrowthQoQ,
    this.netProfitGrowthYoY,
  });

  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      strategyId: json['strategyId'] as int? ?? 0,
      strategyName: json['strategyName'] as String? ?? '이름 없는 전략',
      stockPriceRange: _parseEnum(json['stockPriceRange'], StockPriceRange.values),
      marketCapBucket: _parseEnum(json['marketCapBucket'], MarketCapBucket.values),
      per: _parseRange(json['per']),
      roe: _parseRange(json['roe']),
      debtRatio: _parseRange(json['debtRatio']),
      operatingProfitMargin: _parseRange(json['operatingProfitMargin']), // Note: Check if key matches request (operatingProfitRatio vs Margin)
      netProfitMargin: _parseRange(json['netProfitMargin']),
      dividendYield: _parseRange(json['dividendYield']),
      foreignOwnershipRate: _parseRange(json['foreignOwnershipRate']),
      salesGrowthQoQ: _parseRange(json['salesGrowthQoQ']),
      salesGrowthYoY: _parseRange(json['salesGrowthYoY']),
      netProfitGrowthQoQ: _parseRange(json['netProfitGrowthQoQ']),
      netProfitGrowthYoY: _parseRange(json['netProfitGrowthYoY']),
    );
  }

  static T? _parseEnum<T>(String? value, List<T> values) {
    if (value == null) return null;
    try {
      return values.firstWhere((e) => e.toString().split('.').last == value);
    } catch (_) {
      return null;
    }
  }

  static RangeCondition? _parseRange(dynamic json) {
    if (json == null) return null;
    return RangeCondition(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }

  ScreenerRequest toScreenerRequest() {
    return ScreenerRequest(
      stockPriceRange: stockPriceRange,
      marketCapBucket: marketCapBucket,
      per: per,
      roe: roe,
      debtRatio: debtRatio,
      operatingProfitRatio: operatingProfitMargin, // Map margin to ratio if needed
      netProfitGrowthRatio: netProfitGrowthYoY ?? netProfitGrowthQoQ, // Prefer YoY or QoQ based on logic, or just map what's available
      salesGrowthRatio: salesGrowthYoY ?? salesGrowthQoQ,
      dividendYieldRatio: dividendYield,
      foreignOwnershipRate: foreignOwnershipRate,
    );
  }
}

class StrategyResult {
  final List<Strategy> strategies;

  StrategyResult({required this.strategies});

  factory StrategyResult.fromJson(Map<String, dynamic> json) {
    return StrategyResult(
      strategies: (json['strategies'] as List?)
              ?.map((e) => Strategy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class StrategyResponse {
  final bool isSuccess;
  final StrategyResult? result;

  StrategyResponse({required this.isSuccess, this.result});

  factory StrategyResponse.fromJson(Map<String, dynamic> json) {
    return StrategyResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      result: json['result'] == null ? null : StrategyResult.fromJson(json['result']),
    );
  }
}
