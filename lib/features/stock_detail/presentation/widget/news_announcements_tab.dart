import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/pill_toggle.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/news_announcement_models.dart';

class NewsAnnouncementsTab extends StatefulWidget {
  const NewsAnnouncementsTab({super.key});

  @override
  State<NewsAnnouncementsTab> createState() => _NewsAnnouncementsTabState();
}

class _NewsAnnouncementsTabState extends State<NewsAnnouncementsTab> {
  // true: 뉴스 탭, false: 공시 탭
  bool _isNews = true;

  // [Mock Data] 뉴스 데이터
  final List<NewsResponseItem> _newsList = [
    NewsResponseItem(
      title: '큐로홀딩스, 3분기 영업이익 전년비 15% 증가... "IT 부품 호조"',
      link: 'https://news.naver.com/...',
      pubDate: '1시간 전',
      source: '이데일리',
      thumbnail: 'https://via.placeholder.com/80',
    ),
    NewsResponseItem(
      title: '[특징주] 큐로홀딩스, 신규 계약 체결 소식에 강세',
      link: 'https://news.naver.com/...',
      pubDate: '3시간 전',
      source: '한국경제',
      thumbnail: '',
    ),
    NewsResponseItem(
      title: '반도체 부품주 동반 상승... 큐로홀딩스도 5%대 급등',
      link: 'https://news.naver.com/...',
      pubDate: '5시간 전',
      source: '매일경제',
      thumbnail: 'https://via.placeholder.com/80',
    ),
    NewsResponseItem(
      title: '큐로홀딩스 "주주가치 제고 위해 자사주 매입 검토"',
      link: 'https://news.naver.com/...',
      pubDate: '어제',
      source: '아시아경제',
      thumbnail: '',
    ),
    NewsResponseItem(
      title: '글로벌 공급망 이슈 완화 기대감... 관련주 주목',
      link: 'https://news.naver.com/...',
      pubDate: '2023.12.20',
      source: '파이낸셜뉴스',
      thumbnail: 'https://via.placeholder.com/80',
    ),
  ];

  // [Mock Data] 공시 데이터
  final List<DisclosureItemResponse> _announcementList = [
    DisclosureItemResponse(
      reportName: '단일판매ㆍ공급계약체결',
      receiptNo: '20231224...',
      submitter: '큐로홀딩스',
      date: '2023.12.24',
    ),
    DisclosureItemResponse(
      reportName: '분기보고서 (2023.09)',
      receiptNo: '20231114...',
      submitter: '큐로홀딩스',
      date: '2023.11.14',
    ),
    DisclosureItemResponse(
      reportName: '주주총회소집결의',
      receiptNo: '20231010...',
      submitter: '큐로홀딩스',
      date: '2023.10.10',
    ),
    DisclosureItemResponse(
      reportName: '최대주주등소유주식변동신고서',
      receiptNo: '20230928...',
      submitter: '큐로홀딩스',
      date: '2023.09.28',
    ),
    DisclosureItemResponse(
      reportName: '풍문 또는 보도에 대한 해명',
      receiptNo: '20230915...',
      submitter: '큐로홀딩스',
      date: '2023.09.15',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _isNews ? _buildNewsList() : _buildAnnouncementList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                '뉴스/공시',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                _isNews ? '최신 뉴스' : '전자 공시',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          PillToggle(
            left: '뉴스',
            right: '공시',
            isLeftSelected: _isNews,
            onChanged: (isLeft) => setState(() => _isNews = isLeft),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: _newsList.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final item = _newsList[index];
        final hasImage = item.thumbnail?.isNotEmpty ?? false;

        return InkWell(
          onTap: () {
            // TODO: 뉴스 상세 페이지 또는 웹뷰로 이동
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            item.source,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Container(width: 1, height: 10, color: Colors.grey[300]),
                          const SizedBox(width: 8),
                          Text(
                            item.pubDate,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (hasImage) ...[
                  const SizedBox(width: 16),
                  Container(
                    width: 72,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200], // 이미지 로딩 전/실패 시 배경색
                      image: DecorationImage(
                        image: NetworkImage(item.thumbnail!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: _announcementList.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final item = _announcementList[index];

        return InkWell(
          onTap: () {
            // TODO: 공시 상세 페이지 또는 다트(DART) 웹뷰로 이동
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.tag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF55A4ED), // 앱 메인 컬러
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.reportName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  item.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
