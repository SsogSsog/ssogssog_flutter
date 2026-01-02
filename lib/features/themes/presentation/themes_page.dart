import 'package:flutter/material.dart';

// 각 테마의 데이터를 담는 모델
class ThemeData {
  final String icon;
  final String name;
  final double changeRate;
  final int stockCount;

  const ThemeData({
    required this.icon,
    required this.name,
    required this.changeRate,
    required this.stockCount,
  });
}

/// 요즘 뜨는 테마 목록을 보여주는 페이지
class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  // TODO: 실제 데이터는 외부에서 받아와야 함
  static const List<ThemeData> _dummyThemes = [
    ThemeData(icon: '💾', name: '반도체 대장주', changeRate: 3.2, stockCount: 12),
    ThemeData(icon: '🔋', name: '2차전지/배터리', changeRate: -1.5, stockCount: 25),
    ThemeData(icon: '🤖', name: 'AI / 로봇', changeRate: 5.1, stockCount: 31),
    ThemeData(icon: '💊', name: '바이오 / 제약', changeRate: 0.2, stockCount: 58),
    ThemeData(icon: '🚗', name: '자동차 부품', changeRate: -0.5, stockCount: 18),
    ThemeData(icon: '🛒', name: '소비재 / 유통', changeRate: 1.1, stockCount: 22),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마별 목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          // 검색창
          _buildSearchBar(),
          // 테마 카드 그리드
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 2개씩
                crossAxisSpacing: 12, // 가로 간격
                mainAxisSpacing: 12, // 세로 간격
                childAspectRatio: 0.9, // 카드 가로:세로 비율
              ),
              itemCount: _dummyThemes.length,
              itemBuilder: (context, index) {
                return _ThemeCard(theme: _dummyThemes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 검색창 위젯
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: '테마 또는 종목 검색',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// 테마 하나를 표시하는 카드 위젯
class _ThemeCard extends StatelessWidget {
  final ThemeData theme;

  const _ThemeCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUp = theme.changeRate >= 0;
    final rateColor = isUp ? Colors.red : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. 아이콘 & 등락률
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(theme.icon, style: const TextStyle(fontSize: 32)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: rateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isUp ? '+' : ''}${theme.changeRate}%',
                  style: TextStyle(color: rateColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          // 2. 테마명
          Text(theme.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3)),
          // 3. 종목 개수
          Text(
            '${theme.stockCount}개 종목',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
