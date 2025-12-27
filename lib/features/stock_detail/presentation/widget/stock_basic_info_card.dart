import 'package:flutter/material.dart';

// 위젯에 전달될 데이터 모델
class StockBasicInfoData {
  final String marketCap;
  final String per;
  final String roe;
  final String dividendYield;
  final int week52High;
  final int week52Low;
  final int currentPrice;

  const StockBasicInfoData({
    required this.marketCap,
    required this.per,
    required this.roe,
    required this.dividendYield,
    required this.week52High,
    required this.week52Low,
    required this.currentPrice,
  });
}

/// 종목 상세 - 개요 탭의 '기본 정보' 카드 위젯
class StockBasicInfoCard extends StatelessWidget {
  final StockBasicInfoData data;

  const StockBasicInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('기본 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 2x2 그리드
          Table(
            children: [
              TableRow(
                children: [
                  _buildInfoItem('시가총액', data.marketCap),
                  _buildInfoItem('ROE', data.roe),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildInfoItem('주가수익비율(PER)', data.per),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildInfoItem('배당수익률', data.dividendYield),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 52주 최저/최고
          _build52WeekRange(),
        ],
      ),
    );
  }

  // 그리드 아이템 위젯
  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // 52주 최저/최고 바 위젯
  Widget _build52WeekRange() {
    // 현재 가격이 52주 범위를 벗어날 경우를 대비해, 값을 0.0과 1.0 사이로 제한합니다.
    final double currentPosition = ((data.currentPrice - data.week52Low) / (data.week52High - data.week52Low)).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('52주 최저', style: TextStyle(color: Colors.blue[600], fontSize: 12)),
            Text('52주 최고', style: TextStyle(color: Colors.red[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: currentPosition,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${data.week52Low}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('${data.week52High}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
