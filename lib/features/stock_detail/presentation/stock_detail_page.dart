import 'package:flutter/material.dart';

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
          // 0: 개요 탭 (우리가 구현할 내용)
          Center(child: Text('개요 탭 콘텐츠')),
          // 1: 일별시세 탭
          Center(child: Text('일별시세 탭 콘텐츠')),
          // 2: 재무 탭
          Center(child: Text('재무 탭 콘텐츠')),
          // 3: 뉴스/공시 탭
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
      // 선택 시 라벨과 아이콘 색상
      selectedItemColor: Colors.black,
      // 선택 안된 라벨과 아이콘 색상
      unselectedItemColor: Colors.grey[600],
      // 선택 시 글자 크기
      selectedFontSize: 12,
      // 선택 안된 글자 크기
      unselectedFontSize: 12,
      // 아래 탭 아이템들의 타입 설정 (버튼이 4개 이상일 때 필요)
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
