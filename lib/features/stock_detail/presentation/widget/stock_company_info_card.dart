import 'package:flutter/material.dart';

// 위젯에 전달될 데이터 모델
class StockCompanyInfoData {
  final String sector;
  final String debtRatio;
  final String netProfitMargin;
  final String market;
  final String description;

  const StockCompanyInfoData({
    required this.sector,
    required this.debtRatio,
    required this.netProfitMargin,
    required this.market,
    required this.description,
  });
}

/// 종목 상세 - 개요 탭의 '기업 정보' 카드 위젯
class StockCompanyInfoCard extends StatelessWidget {
  final StockCompanyInfoData data;

  const StockCompanyInfoCard({super.key, required this.data});

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
          const Text('기업 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 2x2 그리드
          Table(
            children: [
              TableRow(
                children: [
                  _buildInfoItem('분야', data.sector),
                  _buildInfoItem('시장 구분', data.market),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildInfoItem('부채비율', data.debtRatio),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: _buildInfoItem('순이익률', data.netProfitMargin),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          // 기업 소개
          Text(
            data.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
          ),
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
}
