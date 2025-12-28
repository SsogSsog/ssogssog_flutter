import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_stability_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_summary_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/performance_chart_card.dart';

/// 종목 상세 페이지의 '재무' 탭 UI 전체를 담고 있는 위젯
class FinancialsTab extends StatelessWidget {
  const FinancialsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 데이터 모델을 외부에서 전달받아야 합니다.

    final List<FinancialMetric> summaryMetrics = [
      const FinancialMetric(name: 'PER', value: '15.8배', evaluation: '보통', badgeColor: Colors.orange),
      const FinancialMetric(name: 'ROE', value: '9.7%', evaluation: '양호', badgeColor: Colors.green),
      const FinancialMetric(name: '배당수익률', value: '2.1%', evaluation: '매력적', badgeColor: Colors.blue),
      const FinancialMetric(name: '부채비율', value: '85%', evaluation: '안정적', badgeColor: Colors.green),
    ];

    const annualData = [
      PerformanceDataPoint(period: '22년', revenue: 1792, operatingProfit: -92, netIncome: -110),
      PerformanceDataPoint(period: '23년', revenue: 1869, operatingProfit: 319, netIncome: 280),
      PerformanceDataPoint(period: '24년', revenue: 2339, operatingProfit: 157, netIncome: 120),
    ];

    const quarterlyData = [
      PerformanceDataPoint(period: '23.1Q', revenue: 450, operatingProfit: 80, netIncome: 70),
      PerformanceDataPoint(period: '23.2Q', revenue: 460, operatingProfit: 85, netIncome: 75),
      PerformanceDataPoint(period: '23.3Q', revenue: 470, operatingProfit: 90, netIncome: 80),
      PerformanceDataPoint(period: '23.4Q', revenue: 489, operatingProfit: 64, netIncome: 55),
    ];

    // 재무 상태 카드용 임시 데이터
    const stabilityData = FinancialStabilityData(
      // 1. 화면에 글자로 보여줄 데이터 (단위 포함)
      totalAssetsStr: '4,567억',
      totalLiabilitiesStr: '2,989억',
      totalEquityStr: '1,578억',

      // 2. 그래프와 비율 계산에 쓸 실제 숫자 데이터 (단위, 콤마 제외)
      // 나중에 DB에서 가져올 때는 Long 타입을 double로 변환해서 넣으면 됨
      totalLiabilitiesVal: 2989,
      totalEquityVal: 1578,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        FinancialSummaryCard(metrics: summaryMetrics),
        const SizedBox(height: 16),
        const PerformanceChartCard(
          annualData: annualData,
          quarterlyData: quarterlyData,
        ),
        const SizedBox(height: 16),
        // #3 재무 상태 카드 위젯 추가
        const FinancialStabilityCard(data: stabilityData),
      ],
    );
  }
}
