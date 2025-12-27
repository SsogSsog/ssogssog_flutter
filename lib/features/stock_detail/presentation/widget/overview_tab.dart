import 'dart:math';
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

    final rnd = Random();

    // 예시: 6개월(약 60영업일) 데이터
    final chartData = List.generate(60, (i) {
      final base = 900 + i * 6;
      return ChartDataPoint(
        price: base + rnd.nextDouble() * 80 - 40,
        volume: 1000000 + rnd.nextDouble() * 5000000,
      );
    });

    // 예시 X축 라벨(원하면 실제 날짜로 바꿔서 넣으면 됨)
    const xTicks = ['12.24', '1.22', '2.20', '3.20', '4.19'];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        StockHeader(data: headerData),
        const SizedBox(height: 16),
        StockChartCard(
          chartData: chartData,
          xTicks: xTicks,
          periodLabel: '지난 6개월 기준',
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#3 기본 정보 카드 영역')),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('#4 기업 정보 카드 영역')),
        ),
      ],
    );
  }
}
