import 'package:flutter/material.dart';

/// 종목 상세 - 개요 탭의 차트 카드 위젯 (단순화 버전)
class StockChartCard extends StatelessWidget {
  const StockChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // 텍스트를 오른쪽으로 정렬
      children: [
        // 1. 주가 차트 + 거래량 차트 영역
        Container(
          height: 250, // 임시 높이
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8), // 약간의 둥근 모서리 추가
          ),
          child: const Center(child: Text('주가 & 거래량 차트')),
        ),
        const SizedBox(height: 8),

        // 2. 기준 기간 텍스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '지난 6개월 기준',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
      ],
    );
  }
}
