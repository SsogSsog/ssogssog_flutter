import 'package:flutter/material.dart';

/// 종목 상세 페이지의 '재무' 탭 UI 전체를 담고 있는 위젯
class FinancialsTab extends StatelessWidget {
  const FinancialsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: const [
        // 1. 재무 요약 카드 (만들 예정)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#1 재무 요약 카드 영역')),
        ),
        SizedBox(height: 16),
        // 2. 실적 분석 그래프 카드 (만들 예정)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#2 실적 분석 그래프 영역')),
        ),
        SizedBox(height: 16),
        // 3. 재무 상태 카드 (만들 예정)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#3 재무 상태 카드 영역')),
        ),
      ],
    );
  }
}
