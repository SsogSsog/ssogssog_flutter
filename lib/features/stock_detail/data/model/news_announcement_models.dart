/// 백엔드 PageDTO 대응
class PageDTO<T> {
  final List<T> content;
  final int currentPage;
  final int size;
  final bool hasNext;
  final int totalContentCount;

  PageDTO({
    required this.content,
    required this.currentPage,
    required this.size,
    required this.hasNext,
    required this.totalContentCount,
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
      totalContentCount: json['totalContentCount'] as int? ?? 0,
    );
  }
}

/// 백엔드 NewsResponseItemDTO 대응
class NewsResponseItem {
  final String title;
  final String link;
  final String pubDate;

  // 클라이언트 UI용 추가 필드 (API 연동 전까지 Mock용, 추후 필요 시 제거 or 별도 관리)
  final String source; 
  final String? thumbnail;

  NewsResponseItem({
    required this.title,
    required this.link,
    required this.pubDate,
    this.source = 'Unknown',
    this.thumbnail,
  });

  factory NewsResponseItem.fromJson(Map<String, dynamic> json) {
    return NewsResponseItem(
      title: json['title'] as String,
      link: json['link'] as String,
      pubDate: json['pubDate'] as String,
      source: json['source'] ?? 'Unknown', // API에는 없지만 UI용
      thumbnail: json['thumbnail'], // API에는 없지만 UI용
    );
  }
}

/// 백엔드 DisclosureItemResponseDTO 대응
class DisclosureItemResponse {
  final String reportName; // 공시 제목
  final String receiptNo;  // 접수번호
  final String submitter;  // 제출인
  final String date;       // 접수일자 (YYYYMMDD)

  // 클라이언트 UI용 추가 필드 (유형 태그 파싱 로직 등은 추후 추가)
  String get tag => '[공시]'; // 임시 태그 로직

  DisclosureItemResponse({
    required this.reportName,
    required this.receiptNo,
    required this.submitter,
    required this.date,
  });

  factory DisclosureItemResponse.fromJson(Map<String, dynamic> json) {
    return DisclosureItemResponse(
      reportName: json['reportName'] as String,
      receiptNo: json['receiptNo'] as String,
      submitter: json['submitter'] as String,
      date: json['date'] as String,
    );
  }
}
