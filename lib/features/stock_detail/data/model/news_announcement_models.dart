/// 공통 응답 래퍼
class ApiResponse<T> {
  final bool isSuccess;
  final String code;
  final String message;
  final T result;

  ApiResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: fromJsonT(json['result'] ?? {}),
    );
  }
}

/// 백엔드 PageDTO 대응
class PageDTO<T> {
  final List<T> content;
  final int currentPage;
  final int size;
  final bool hasNext;

  PageDTO({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
  });

  factory PageDTO.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return PageDTO<T>(
      content: contentList.map((e) => fromJsonT(e)).toList(),
      currentPage: json['currentPage'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }
}

/// 백엔드 NewsResponseItemDTO 대응
class NewsResponseItem {
  final String title;
  final String link;
  final String pubDate;

  NewsResponseItem({
    required this.title,
    required this.link,
    required this.pubDate,
  });

  factory NewsResponseItem.fromJson(Map<String, dynamic> json) {
    return NewsResponseItem(
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      pubDate: json['pubDate'] as String? ?? '',
    );
  }
}

/// 백엔드 DisclosureItemResponseDTO 대응
class DisclosureItemResponse {
  final String reportName; // 공시 제목
  final String receiptNo;  // 접수번호
  final String submitter;  // 제출인
  final String date;       // 접수일자 (YYYYMMDD)

  DisclosureItemResponse({
    required this.reportName,
    required this.receiptNo,
    required this.submitter,
    required this.date,
  });

  factory DisclosureItemResponse.fromJson(Map<String, dynamic> json) {
    return DisclosureItemResponse(
      reportName: json['reportName'] as String? ?? '',
      receiptNo: json['receiptNo'] as String? ?? '',
      submitter: json['submitter'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}
