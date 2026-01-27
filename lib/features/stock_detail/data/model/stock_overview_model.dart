class StockOverviewResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final StockOverview? result;

  StockOverviewResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    this.result,
  });

  factory StockOverviewResponse.fromJson(Map<String, dynamic> json) {
    return StockOverviewResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: json['result'] != null ? StockOverview.fromJson(json['result']) : null,
    );
  }
}

class StockOverview {
  final String stockName;
  final String stockCode;
  final PriceInfo priceInfo;
  final ChartData chartData;
  final FinancialInfo financialInfo;
  final CompanyInfo companyInfo;
  final String companyDescription;

  StockOverview({
    required this.stockName,
    required this.stockCode,
    required this.priceInfo,
    required this.chartData,
    required this.financialInfo,
    required this.companyInfo,
    required this.companyDescription,
  });

  factory StockOverview.fromJson(Map<String, dynamic> json) {
    return StockOverview(
      stockName: json['stockName'] ?? '',
      stockCode: json['stockCode'] ?? '',
      priceInfo: PriceInfo.fromJson(json['priceInfo'] ?? {}),
      chartData: ChartData.fromJson(json['chartData'] ?? {}),
      financialInfo: FinancialInfo.fromJson(json['financialInfo'] ?? {}),
      companyInfo: CompanyInfo.fromJson(json['companyInfo'] ?? {}),
      companyDescription: json['companyDescription'] ?? '',
    );
  }
}

class PriceInfo {
  final int currentPrice;
  final int changeAmount;
  final double changeRate;
  final int previousClose;
  final int previousVolume;

  PriceInfo({
    required this.currentPrice,
    required this.changeAmount,
    required this.changeRate,
    required this.previousClose,
    required this.previousVolume,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      currentPrice: json['currentPrice'] ?? 0,
      changeAmount: json['changeAmount'] ?? 0,
      changeRate: (json['changeRate'] ?? 0.0).toDouble(),
      previousClose: json['previousClose'] ?? 0,
      previousVolume: json['previousVolume'] ?? 0,
    );
  }
}

class ChartData {
  final List<ChartHistoryItem> priceHistory;
  final List<ChartHistoryItem> volumeHistory;

  ChartData({
    required this.priceHistory,
    required this.volumeHistory,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      priceHistory: (json['priceHistory'] as List?)
              ?.map((e) => ChartHistoryItem.fromJson(e))
              .toList() ??
          [],
      volumeHistory: (json['volumeHistory'] as List?)
              ?.map((e) => ChartHistoryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ChartHistoryItem {
  final String date;
  final int? price;
  final int? volume;

  ChartHistoryItem({
    required this.date,
    this.price,
    this.volume,
  });

  factory ChartHistoryItem.fromJson(Map<String, dynamic> json) {
    return ChartHistoryItem(
      date: json['date'] ?? '',
      price: json['price'],
      volume: json['volume'],
    );
  }
}

class FinancialInfo {
  final int marketCap;
  final double roe;
  final double per;
  final double dividendYield;
  final Week52Range week52Range;

  FinancialInfo({
    required this.marketCap,
    required this.roe,
    required this.per,
    required this.dividendYield,
    required this.week52Range,
  });

  factory FinancialInfo.fromJson(Map<String, dynamic> json) {
    return FinancialInfo(
      marketCap: json['marketCap'] ?? 0,
      roe: (json['roe'] ?? 0.0).toDouble(),
      per: (json['per'] ?? 0.0).toDouble(),
      dividendYield: (json['dividendYield'] ?? 0.0).toDouble(),
      week52Range: Week52Range.fromJson(json['week52Range'] ?? {}),
    );
  }
}

class Week52Range {
  final int low;
  final int high;

  Week52Range({
    required this.low,
    required this.high,
  });

  factory Week52Range.fromJson(Map<String, dynamic> json) {
    return Week52Range(
      low: json['low'] ?? 0,
      high: json['high'] ?? 0,
    );
  }
}

class CompanyInfo {
  final String sector;
  final String market;
  final double debtRate;
  final double netProfitMargin;

  CompanyInfo({
    required this.sector,
    required this.market,
    required this.debtRate,
    required this.netProfitMargin,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      sector: json['sector'] ?? '',
      market: json['market'] ?? '',
      debtRate: (json['debtRate'] ?? 0.0).toDouble(),
      netProfitMargin: (json['netProfitMargin'] ?? 0.0).toDouble(),
    );
  }
}
