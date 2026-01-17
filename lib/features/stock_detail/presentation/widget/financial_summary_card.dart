import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/stock_detail/presentation/logic/financial_evaluator.dart';

// 개별 재무 지표 데이터 모델
class FinancialMetric {
  final String name;
  final String displayValue; // 화면 표시용 (예: "15.8배")
  final double rawValue;     // 계산용 (예: 15.8)
  final FinancialMetricType type; // 지표 타입

  const FinancialMetric({
    required this.name,
    required this.displayValue,
    required this.rawValue,
    required this.type,
  });
}

enum FinancialMetricType {
  per,
  pbr,
  roe,
  dividendYield,
  debtRatio,
}

/// 종목 상세 - 재무 탭의 '재무 요약' 카드
class FinancialSummaryCard extends StatelessWidget {
  final List<FinancialMetric> metrics;

  const FinancialSummaryCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('재무 요약', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2, // 한 줄에 2개씩
            shrinkWrap: true, // 내용의 크기에 맞게 높이 조절
            physics: const NeverScrollableScrollPhysics(), // GridView 자체 스크롤 비활성화
            childAspectRatio: 2.5, // 가로:세로 비율
            mainAxisSpacing: 16, // 세로 간격
            crossAxisSpacing: 16, // 가로 간격
            padding: EdgeInsets.zero,
            children: metrics.map((metric) => _MetricTile(metric: metric)).toList(),
          ),
        ],
      ),
    );
  }
}

/// 재무 지표 하나를 표시하는 타일 위젯
class _MetricTile extends StatelessWidget {
  final FinancialMetric metric;

  const _MetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    // FinancialEvaluator를 사용하여 평가 결과 가져오기
    FinancialEvaluation evaluation;
    
    switch (metric.type) {
      case FinancialMetricType.per:
        evaluation = FinancialEvaluator.evaluatePER(metric.rawValue);
        break;
      case FinancialMetricType.pbr:
        evaluation = FinancialEvaluator.evaluatePBR(metric.rawValue);
        break;
      case FinancialMetricType.roe:
        evaluation = FinancialEvaluator.evaluateROE(metric.rawValue);
        break;
      case FinancialMetricType.dividendYield:
        evaluation = FinancialEvaluator.evaluateDividendYield(metric.rawValue);
        break;
      case FinancialMetricType.debtRatio:
        evaluation = FinancialEvaluator.evaluateDebtRatio(metric.rawValue);
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(metric.name, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(metric.displayValue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: evaluation.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                evaluation.label,
                style: TextStyle(
                  color: evaluation.color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
