import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/model/financials_model.dart';
import 'package:ssogssog_flutter/features/stock_detail/data/repository/stock_detail_repository.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_stability_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/financial_summary_card.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/widget/performance_chart_card.dart';

/// 종목 상세 페이지의 '재무' 탭 UI 전체를 담고 있는 위젯
class FinancialsTab extends StatefulWidget {
  final String stockName;
  final String stockCode;

  const FinancialsTab({
    super.key,
    required this.stockName,
    required this.stockCode,
  });

  @override
  State<FinancialsTab> createState() => _FinancialsTabState();
}

class _FinancialsTabState extends State<FinancialsTab> with AutomaticKeepAliveClientMixin {
  final StockDetailRepository _repository = StockDetailRepository();
  FinancialsResult? _financialsData;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchFinancials();
  }

  Future<void> _fetchFinancials() async {
    setState(() => _isLoading = true);
    final data = await _repository.getFinancials(widget.stockCode);
    if (mounted) {
      setState(() {
        _financialsData = data;
        _isLoading = false;
      });
    }
  }

  String _formatEok(double value) {
    return '${NumberFormat('#,###').format(value.round())}억';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_financialsData == null) {
      return const Center(child: Text('재무 정보를 불러올 수 없습니다.'));
    }

    final summary = _financialsData!.summary;
    final performance = _financialsData!.performance;
    final stability = _financialsData!.stability;

    final List<FinancialMetric> summaryMetrics = [
      FinancialMetric(
        name: 'PER',
        displayValue: '${summary.per.toStringAsFixed(2)}배',
        rawValue: summary.per,
        type: FinancialMetricType.per,
      ),
      FinancialMetric(
        name: 'ROE',
        displayValue: '${summary.roe.toStringAsFixed(2)}%',
        rawValue: summary.roe,
        type: FinancialMetricType.roe,
      ),
      FinancialMetric(
        name: '배당수익률',
        displayValue: '${summary.dividendYield.toStringAsFixed(2)}%',
        rawValue: summary.dividendYield,
        type: FinancialMetricType.dividendYield,
      ),
      FinancialMetric(
        name: '부채비율',
        displayValue: '${summary.debtRatio.toStringAsFixed(2)}%',
        rawValue: summary.debtRatio,
        type: FinancialMetricType.debtRatio,
      ),
      // PBR은 API에 없으므로 임시 처리 (요청사항)
      const FinancialMetric(
        name: 'PBR',
        displayValue: '-',
        rawValue: 0.0,
        type: FinancialMetricType.pbr,
      ),
    ];

    final annualData = performance.annual.map((item) {
      return PerformanceDataPoint(
        period: '${item.year}년',
        revenue: item.revenue / 100000000, // 원 단위를 억 단위로 변환
        operatingProfit: item.operatingProfit / 100000000,
        netIncome: item.netIncome / 100000000,
      );
    }).toList();

    final quarterlyData = performance.quarterly.map((item) {
      return PerformanceDataPoint(
        period: '${item.year.toString().substring(2)}.${item.quarter}',
        revenue: item.revenue / 100000000,
        operatingProfit: item.operatingProfit / 100000000,
        netIncome: item.netIncome / 100000000,
      );
    }).toList();

    // 자산총계 = 부채총계 + 자본총계
    final totalAssetsVal = stability.totalLiabilities + stability.totalEquity;
    
    // 억 단위 변환
    final totalAssetsStr = _formatEok(totalAssetsVal / 100000000);
    final totalLiabilitiesStr = _formatEok(stability.totalLiabilities / 100000000);
    final totalEquityStr = _formatEok(stability.totalEquity / 100000000);

    final stabilityData = FinancialStabilityData(
      totalAssetsStr: totalAssetsStr,
      totalLiabilitiesStr: totalLiabilitiesStr,
      totalEquityStr: totalEquityStr,
      totalLiabilitiesVal: stability.totalLiabilities,
      totalEquityVal: stability.totalEquity,
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
                  '${widget.stockName}  ${widget.stockCode}',
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

        if (annualData.isNotEmpty || quarterlyData.isNotEmpty)
          PerformanceChartCard(
            annualData: annualData,
            quarterlyData: quarterlyData,
          ),
        if (annualData.isNotEmpty || quarterlyData.isNotEmpty)
          const SizedBox(height: 16),

        FinancialStabilityCard(data: stabilityData),
      ],
    );
  }
}