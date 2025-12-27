import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_basic_info_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_chart_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/stock_company_info_card.dart';
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
    final chartData = List.generate(60, (i) {
      final base = 900 + i * 6;
      return ChartDataPoint(
        price: base + rnd.nextDouble() * 80 - 40,
        volume: 1000000 + rnd.nextDouble() * 5000000,
      );
    });
    const xTicks = ['12.24', '1.22', '2.20', '3.20', '4.19'];

    const basicInfoData = StockBasicInfoData(
      marketCap: '1,234억',
      per: '15.8배',
      roe: '9.7%',
      dividendYield: '-',
      week52High: 1874,
      week52Low: 1060,
      currentPrice: 1275, 
    );

    // [핵심 추가] 기업 정보 카드용 임시 데이터
    const companyInfoData = StockCompanyInfoData(
      sector: 'IT 부품',
      debtRatio: '85%',
      netProfitMargin: '9.4%',
      market: 'KOSDAQ',
      description: 'IT 부품 사업을 영위하는 기업으로, 최근 매출 신장세를 유지하고 있으며 재무 구조는 비교적 안정적인 편입니다.',
    );

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
        StockBasicInfoCard(data: basicInfoData),
        const SizedBox(height: 16),
        
        // [핵심 수정] #4 기업 정보 카드 위젯 추가
        StockCompanyInfoCard(data: companyInfoData),
      ],
    );
  }
}
