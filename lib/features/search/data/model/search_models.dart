
class SearchStockItem {
  final int stockId;
  final String corpName;
  final String stockCode;
  final int closePrice;
  final int volume;
  final double changeRate;

  SearchStockItem({
    required this.stockId,
    required this.corpName,
    required this.stockCode,
    required this.closePrice,
    required this.volume,
    required this.changeRate,
  });

  factory SearchStockItem.fromJson(Map<String, dynamic> json) {
    return SearchStockItem(
      stockId: json['stockId'] as int? ?? 0,
      corpName: json['corpName'] as String? ?? '',
      stockCode: json['stockCode'] as String? ?? '',
      closePrice: json['closePrice'] as int? ?? 0,
      volume: json['volume'] as int? ?? 0,
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AutocompleteResponse {
  final bool isSuccess;
  final String message;
  final List<SearchStockItem> result;

  AutocompleteResponse({
    required this.isSuccess,
    required this.message,
    required this.result,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutocompleteResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      result: (json['result'] as List?)
              ?.map((e) => SearchStockItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SearchResultContent {
  final List<SearchStockItem> content;
  final int currentPage;
  final int size;
  final bool hasNext;
  final int totalContentCount;

  SearchResultContent({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
    required this.totalContentCount,
  });

  factory SearchResultContent.fromJson(Map<String, dynamic> json) {
    return SearchResultContent(
      content: (json['content'] as List?)
              ?.map((e) => SearchStockItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      totalContentCount: json['totalContentCount'] as int? ?? 0,
    );
  }
}

class SearchResponse {
  final bool isSuccess;
  final String message;
  final SearchResultContent? result;

  SearchResponse({
    required this.isSuccess,
    required this.message,
    this.result,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      result: json['result'] != null
          ? SearchResultContent.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }
}
