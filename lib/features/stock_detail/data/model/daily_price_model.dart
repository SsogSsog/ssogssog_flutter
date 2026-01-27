class DailyPriceResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final DailyPriceResult result;

  DailyPriceResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory DailyPriceResponse.fromJson(Map<String, dynamic> json) {
    return DailyPriceResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: DailyPriceResult.fromJson(json['result'] ?? {}),
    );
  }
}

class DailyPriceResult {
  final List<DailyPriceItem> content;
  final int currentPage;
  final int size;
  final bool hasNext;

  DailyPriceResult({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
  });

  factory DailyPriceResult.fromJson(Map<String, dynamic> json) {
    return DailyPriceResult(
      content: (json['content'] as List?)
              ?.map((e) => DailyPriceItem.fromJson(e))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 0,
      size: json['size'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }
}

class DailyPriceItem {
  final String date;
  final int closePrice;
  final int changePrice;
  final double changeRate;
  final int volume;

  DailyPriceItem({
    required this.date,
    required this.closePrice,
    required this.changePrice,
    required this.changeRate,
    required this.volume,
  });

  factory DailyPriceItem.fromJson(Map<String, dynamic> json) {
    return DailyPriceItem(
      date: json['date'] ?? '',
      closePrice: json['closePrice'] ?? 0,
      changePrice: json['changePrice'] ?? 0,
      changeRate: (json['changeRate'] ?? 0).toDouble(),
      volume: json['volume'] ?? 0,
    );
  }
}
