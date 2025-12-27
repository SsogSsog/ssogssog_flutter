import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/overview_tab.dart';

class StockDetailPage extends StatefulWidget {
  final String stockCode;

  const StockDetailPage({super.key, required this.stockCode});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  int _selectedTabIndex = 0;
  final List<String> tabNames = ['개요', '일별시세', '재무', '뉴스/공시'];

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 종목 데이터를 stockCode를 이용해 가져와야 함
    const String stockName = "큐로홀딩스";

    return Scaffold(
      appBar: AppBar(
        // [핵심 수정] AppBar에 종목명만 표시하도록 변경
        title: Text(
          '$stockName (${widget.stockCode})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0, // 타이틀의 왼쪽 기본 여백 제거
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: const [
          OverviewTab(),
          Center(child: Text('일별시세 탭 콘텐츠')),
          Center(child: Text('재무 탭 콘텐츠')),
          Center(child: Text('뉴스/공시 탭 콘텐츠')),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '개요'),
        BottomNavigationBarItem(icon: Icon(Icons.candlestick_chart), label: '일별시세'),
        BottomNavigationBarItem(icon: Icon(Icons.assessment), label: '재무'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: '뉴스/공시'),
      ],
    );
  }
}
