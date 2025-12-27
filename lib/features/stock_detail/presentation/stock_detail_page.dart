import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/overview_tab.dart'; // [추가]

class StockDetailPage extends StatefulWidget {
  final String stockCode; // 라우터로부터 전달받을 종목 코드

  const StockDetailPage({super.key, required this.stockCode});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  int _selectedTabIndex = 0; // 현재 선택된 하단 탭 인덱스 (0: 개요)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 페이지 제목 없이 뒤로가기 버튼만 있는 깔끔한 AppBar
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: const [
          // [핵심 수정] '개요' 탭의 내용을 OverviewTab 위젯으로 교체
          OverviewTab(),
          Center(child: Text('일별시세 탭 콘텐츠')),
          Center(child: Text('재무 탭 콘텐츠')),
          Center(child: Text('뉴스/공시 탭 콘텐츠')),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 하단 탭 네비게이션 바 위젯
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
