class FinancialsResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final FinancialsResult result;

  FinancialsResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory FinancialsResponse.fromJson(Map<String, dynamic> json) {
    return FinancialsResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: FinancialsResult.fromJson(json['result'] ?? {}),
    );
  }
}

class FinancialsResult {
  final FinancialSummary summary;
  final FinancialPerformance performance;
  final FinancialStability stability;

  FinancialsResult({
    required this.summary,
    required this.performance,
    required this.stability,
  });

  factory FinancialsResult.fromJson(Map<String, dynamic> json) {
    return FinancialsResult(
      summary: FinancialSummary.fromJson(json['summary'] ?? {}),
      performance: FinancialPerformance.fromJson(json['performance'] ?? {}),
      stability: FinancialStability.fromJson(json['stability'] ?? {}),
    );
  }
}

class FinancialSummary {
  final double per;
  final double roe;
  final double dividendYield;
  final double debtRatio;

  FinancialSummary({
    required this.per,
    required this.roe,
    required this.dividendYield,
    required this.debtRatio,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      per: (json['per'] ?? 0.0).toDouble(),
      roe: (json['roe'] ?? 0.0).toDouble(),
      dividendYield: (json['dividendYield'] ?? 0.0).toDouble(),
      debtRatio: (json['debtRatio'] ?? 0.0).toDouble(),
    );
  }
}

class FinancialPerformance {
  final List<PerformanceItem> annual;
  final List<PerformanceItem> quarterly;

  FinancialPerformance({
    required this.annual,
    required this.quarterly,
  });

  factory FinancialPerformance.fromJson(Map<String, dynamic> json) {
    return FinancialPerformance(
      annual: (json['annual'] as List?)
              ?.map((e) => PerformanceItem.fromJson(e))
              .toList() ??
          [],
      quarterly: (json['quarterly'] as List?)
              ?.map((e) => PerformanceItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PerformanceItem {
  final int year;
  final String quarter;
  final double revenue;
  final double operatingProfit;
  final double netIncome;
  final bool isConsolidated;

  PerformanceItem({
    required this.year,
    required this.quarter,
    required this.revenue,
    required this.operatingProfit,
    required this.netIncome,
    required this.isConsolidated,
  });

  factory PerformanceItem.fromJson(Map<String, dynamic> json) {
    return PerformanceItem(
      year: json['year'] ?? 0,
      quarter: json['quarter'] ?? '',
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      operatingProfit: (json['operatingProfit'] ?? 0.0).toDouble(),
      netIncome: (json['netIncome'] ?? 0.0).toDouble(),
      isConsolidated: json['isConsolidated'] ?? false,
    );
  }
}

class FinancialStability {
  final double totalLiabilities;
  final double totalEquity;
  final bool isConsolidated;

  FinancialStability({
    required this.totalLiabilities,
    required this.totalEquity,
    required this.isConsolidated,
  });

  factory FinancialStability.fromJson(Map<String, dynamic> json) {
    return FinancialStability(
      totalLiabilities: (json['totalLiabilities'] ?? 0.0).toDouble(),
      totalEquity: (json['totalEquity'] ?? 0.0).toDouble(),
      isConsolidated: json['isConsolidated'] ?? false,
    );
  }
}
