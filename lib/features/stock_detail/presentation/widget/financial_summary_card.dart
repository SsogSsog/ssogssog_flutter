import 'package:flutter/material.dart';

// 개별 재무 지표 데이터 모델
class FinancialMetric {
  final String name;
  final String value;
  final String evaluation;
  final Color badgeColor;

  const FinancialMetric({
    required this.name,
    required this.value,
    required this.evaluation,
    required this.badgeColor,
  });
}

/// 종목 상세 - 재무 탭의 '재무 요약' 카드
class FinancialSummaryCard extends StatelessWidget {
  final List<FinancialMetric> metrics;

  const FinancialSummaryCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('재무 요약', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, // 한 줄에 2개씩
            shrinkWrap: true, // 내용의 크기에 맞게 높이 조절
            physics: const NeverScrollableScrollPhysics(), // GridView 자체 스크롤 비활성화
            childAspectRatio: 2.5, // 가로:세로 비율
            mainAxisSpacing: 16, // 세로 간격
            crossAxisSpacing: 16, // 가로 간격
            children: metrics.map((metric) => _MetricTile(metric: metric)).toList(),
          ),
        ],
      ),
    );
  }
}

/// 재무 지표 하나를 표시하는 타일 위젯
// TODO 내부 로직으로 각각 값의 수치 범위에 따라 직접 평가와 색상을 결정하는 로직 만들기
class _MetricTile extends StatelessWidget {
  final FinancialMetric metric;

  const _MetricTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(metric.name, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(metric.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: metric.badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                metric.evaluation,
                style: TextStyle(
                  color: metric.badgeColor,
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
