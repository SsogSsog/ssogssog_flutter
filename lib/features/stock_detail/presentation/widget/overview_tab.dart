import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_chart_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_header.dart';

/// 종목 상세 페이지의 '개요' 탭 UI 전체를 담고 있는 위젯
class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 데이터 모델을 외부에서 전달받아야 합니다.
    const headerData = StockHeaderData(
      name: '큐로홀딩스',
      code: '051780',
      currentPrice: 1275,
      change: 95,
      changeRate: 8.05,
      volume: 2517785,
      prevClose: 1180,
      market: 'KOSDAQ',
    );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: const [
        StockHeader(data: headerData),
        SizedBox(height: 24),

        // [핵심 수정] #2 차트 위젯 추가
        StockChartCard(),
        SizedBox(height: 24),
        
        // 3. 기본 정보 카드 (만들 예정)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#3 기본 정보 카드 영역')),
        ),
        SizedBox(height: 16),
        // 4. 기업 정보 카드 (만들 예정)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#4 기업 정보 카드 영역')),
        ),
      ],
    );
  }
}
