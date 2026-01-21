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
