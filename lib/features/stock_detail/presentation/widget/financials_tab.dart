import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_stability_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_summary_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/performance_chart_card.dart';

/// 종목 상세 페이지의 '재무' 탭 UI 전체를 담고 있는 위젯
class FinancialsTab extends StatelessWidget {
  final String stockName;
  final String stockCode;

  const FinancialsTab({
    super.key,
    required this.stockName,
    required this.stockCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    const stabilityData = FinancialStabilityData(
      totalAssetsStr: '4,567억',
      totalLiabilitiesStr: '2,989억',
      totalEquityStr: '1,578억',
      totalLiabilitiesVal: 2989,
      totalEquityVal: 1578,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '재무',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$stockName  $stockCode',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.70),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        FinancialSummaryCard(metrics: summaryMetrics),
        const SizedBox(height: 16),

        PerformanceChartCard(
          annualData: annualData,
          quarterlyData: quarterlyData,
        ),
        const SizedBox(height: 16),

        FinancialStabilityCard(data: stabilityData),
      ],
    );
  }
}