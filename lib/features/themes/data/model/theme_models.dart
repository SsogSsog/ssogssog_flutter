class ThemeItem {
  final String themeName;
  final String emoji;
  final double changeRateAverage;
  final int totalCount; // Stock count in this theme

  ThemeItem({
    required this.themeName,
    required this.emoji,
    required this.changeRateAverage,
    required this.totalCount,
  });

  factory ThemeItem.fromJson(Map<String, dynamic> json) {
    return ThemeItem(
      themeName: json['themeName'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '📦', // Default emoji if missing
      changeRateAverage: (json['changeRateAverage'] as num?)?.toDouble() ?? 0.0,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class ThemeStatsResult {
  final List<ThemeItem> items;
  final int totalCount; // Total themes count?

  ThemeStatsResult({
    required this.items,
    required this.totalCount,
  });

  factory ThemeStatsResult.fromJson(Map<String, dynamic> json) {
    return ThemeStatsResult(
      items: (json['items'] as List?)
              ?.map((e) => ThemeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class ThemeStatsResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final ThemeStatsResult result;

  ThemeStatsResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory ThemeStatsResponse.fromJson(Map<String, dynamic> json) {
    return ThemeStatsResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      result: json['result'] != null
          ? ThemeStatsResult.fromJson(json['result'] as Map<String, dynamic>)
          : ThemeStatsResult(items: [], totalCount: 0),
    );
  }
}

// --- Detail Page Models ---

class ThemeCountResult {
  final int totalCount;
  final int risingCount;
  final int fallingCount;

  ThemeCountResult({
    required this.totalCount,
    required this.risingCount,
    required this.fallingCount,
  });

  factory ThemeCountResult.fromJson(Map<String, dynamic> json) {
    return ThemeCountResult(
      totalCount: json['totalCount'] as int? ?? 0,
      risingCount: json['risingCount'] as int? ?? 0,
      fallingCount: json['fallingCount'] as int? ?? 0,
    );
  }
}

class ThemeCountResponse {
  final bool isSuccess;
  final String message;
  final ThemeCountResult result;

  ThemeCountResponse({
    required this.isSuccess,
    required this.message,
    required this.result,
  });

  factory ThemeCountResponse.fromJson(Map<String, dynamic> json) {
    return ThemeCountResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      result: json['result'] != null
          ? ThemeCountResult.fromJson(json['result'] as Map<String, dynamic>)
          : ThemeCountResult(totalCount: 0, risingCount: 0, fallingCount: 0),
    );
  }
}

class ThemeStockItem {
  final int stockId;
  final String corpName;
  final String stockCode;
  final int closePrice;
  final int volume;
  final double changeRate;

  ThemeStockItem({
    required this.stockId,
    required this.corpName,
    required this.stockCode,
    required this.closePrice,
    required this.volume,
    required this.changeRate,
  });

  factory ThemeStockItem.fromJson(Map<String, dynamic> json) {
    return ThemeStockItem(
      stockId: json['stockId'] as int? ?? 0,
      corpName: json['corpName'] as String? ?? '',
      stockCode: json['stockCode'] as String? ?? '',
      closePrice: json['closePrice'] as int? ?? 0,
      volume: json['volume'] as int? ?? 0,
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ThemeStockResult {
  final List<ThemeStockItem> content;
  final int currentPage;
  final int size;
  final bool hasNext;
  final int totalContentCount;

  ThemeStockResult({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
    required this.totalContentCount,
  });

  factory ThemeStockResult.fromJson(Map<String, dynamic> json) {
    return ThemeStockResult(
      content: (json['content'] as List?)
              ?.map((e) => ThemeStockItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      totalContentCount: json['totalContentCount'] as int? ?? 0,
    );
  }
}

class ThemeStockResponse {
  final bool isSuccess;
  final String message;
  final ThemeStockResult? result;

  ThemeStockResponse({
    required this.isSuccess,
    required this.message,
    this.result,
  });

  factory ThemeStockResponse.fromJson(Map<String, dynamic> json) {
    return ThemeStockResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      result: json['result'] != null
          ? ThemeStockResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }
}

