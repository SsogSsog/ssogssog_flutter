import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/pill_toggle.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/news_announcement_models.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/repository/stock_detail_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsAnnouncementsTab extends StatefulWidget {
  final String stockCode;

  const NewsAnnouncementsTab({
    super.key,
    required this.stockCode,
  });

  @override
  State<NewsAnnouncementsTab> createState() => _NewsAnnouncementsTabState();
}

class _NewsAnnouncementsTabState extends State<NewsAnnouncementsTab> with AutomaticKeepAliveClientMixin {
  final StockDetailRepository _repository = StockDetailRepository();

  // true: 뉴스 탭, false: 공시 탭
  bool _isNews = true;

  // News State
  final List<NewsResponseItem> _newsList = [];
  bool _isNewsLoading = false;
  int _newsPage = 0;
  bool _newsHasNext = true;

  // Disclosure State
  final List<DisclosureItemResponse> _announcementList = [];
  bool _isDisclosureLoading = false;
  int _disclosurePage = 0;
  bool _disclosureHasNext = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _fetchDisclosures();
  }

  Future<void> _fetchNews() async {
    if (_isNewsLoading || !_newsHasNext) return;
    setState(() => _isNewsLoading = true);

    final result = await _repository.getNews(widget.stockCode, page: _newsPage);
    
    if (mounted) {
      if (result != null) {
        setState(() {
          _newsList.addAll(result.content);
          _newsHasNext = result.hasNext;
          if (result.hasNext) _newsPage++;
        });
      }
      setState(() => _isNewsLoading = false);
    }
  }

  Future<void> _fetchDisclosures() async {
    if (_isDisclosureLoading || !_disclosureHasNext) return;
    setState(() => _isDisclosureLoading = true);

    final result = await _repository.getDisclosures(widget.stockCode, page: _disclosurePage);

    if (mounted) {
      if (result != null) {
        setState(() {
          _announcementList.addAll(result.content);
          _disclosureHasNext = result.hasNext;
          if (result.hasNext) _disclosurePage++;
        });
      }
      setState(() => _isDisclosureLoading = false);
    }
  }

  void _onLinkTap(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
    if (_newsList.isEmpty) {
      return _isNewsLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text('관련 뉴스가 없습니다.'));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isNewsLoading &&
            _newsHasNext &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          _fetchNews();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        itemCount: _newsList.length + (_newsHasNext ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          if (index == _newsList.length) {
            return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
          }

          final item = _newsList[index];

          return InkWell(
            onTap: () => _onLinkTap(item.link),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('&quot;', '"'),
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
                      // Source가 없으므로 생략하거나 기본값 표시
                      Text(
                        item.pubDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementList() {
    if (_announcementList.isEmpty) {
      return _isDisclosureLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text('관련 공시가 없습니다.'));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isDisclosureLoading &&
            _disclosureHasNext &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
          _fetchDisclosures();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        itemCount: _announcementList.length + (_disclosureHasNext ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          if (index == _announcementList.length) {
            return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
          }

          final item = _announcementList[index];
          // DART 공시 링크 생성 (receiptNo 활용)
          final link = 'http://dart.fss.or.kr/dsaf001/main.do?rcpNo=${item.receiptNo}';

          return InkWell(
            onTap: () => _onLinkTap(link),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '[공시]',
                          style: TextStyle(
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
                        const SizedBox(height: 4),
                        Text(
                          item.submitter,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
      ),
    );
  }
}
