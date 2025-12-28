import 'package:flutter/material.dart';

// 데이터 모델 (비율 계산을 위해 double 타입 추가)
class FinancialStabilityData {
  final String totalAssetsStr;      // 화면 표시용 (예: "4,567억")
  final String totalLiabilitiesStr; // 화면 표시용 (예: "2,989억")
  final String totalEquityStr;      // 화면 표시용 (예: "1,578억")

  // 그래프 비율 계산용 실제 숫자 (단위 상관 없음, 비율만 맞으면 됨)
  final double totalLiabilitiesVal;
  final double totalEquityVal;

  const FinancialStabilityData({
    required this.totalAssetsStr,
    required this.totalLiabilitiesStr,
    required this.totalEquityStr,
    required this.totalLiabilitiesVal,
    required this.totalEquityVal,
  });

  // 부채비율 계산 (부채 / 자본 * 100)
  double get debtRatio {
    if (totalEquityVal <= 0) return 0.0;  // 또는 적절한 기본값
      return (totalLiabilitiesVal / totalEquityVal) * 100;
    }
}

class FinancialStabilityCard extends StatelessWidget {
  final FinancialStabilityData data;

  const FinancialStabilityCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 테마 컬러 설정 (앱의 브랜드 컬러에 맞게 조정하세요)
    // 부채는 약간 경고 느낌(주황/빨강) 혹은 중립(회색), 자본은 긍정(파랑/초록) 추천
    final liabilityColor = Colors.orange.shade300;
    final equityColor = Colors.blue.shade300;

    // 전체 자산 대비 비율 계산 (Flex에 넣기 위함)
    final total = data.totalLiabilitiesVal + data.totalEquityVal;
    // 소수점 문제 방지를 위해 정수 Flex 값으로 변환
    final int liabilityFlex = ((data.totalLiabilitiesVal / total) * 100).round();
    final int equityFlex = 100 - liabilityFlex;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // 카드 배경
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
          // 1. 헤더 (제목 + 부채비율 뱃지)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '재무 안전성',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildDebtRatioBadge(data.debtRatio),
            ],
          ),
          const SizedBox(height: 24),

          // 2. 핵심 시각화 (Stacked Bar Graph)
          // "자산 = 부채 + 자본"을 하나의 막대로 표현
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 24, // 막대 두께
              child: Row(
                children: [
                  // 부채 영역
                  Expanded(
                    flex: liabilityFlex,
                    child: Container(
                      color: liabilityColor,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 8),
                      // 공간이 좁으면 텍스트 숨김 처리 등을 해야 할 수도 있음
                    ),
                  ),
                  // 자본 영역
                  Expanded(
                    flex: equityFlex,
                    child: Container(
                      color: equityColor,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 3. 하단 상세 정보 (범례 역할)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 부채 정보
              _buildLegendItem(
                title: "부채총계",
                value: data.totalLiabilitiesStr,
                color: liabilityColor,
                align: CrossAxisAlignment.start,
              ),
              // 자본 정보
              _buildLegendItem(
                title: "자본총계",
                value: data.totalEquityStr,
                color: equityColor,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 12),

          // 4. 자산 총계 (결론)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("자산총계 (부채+자본)", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Text(
                  data.totalAssetsStr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
            ],
          )
        ],
      ),
    );
  }

  // 부채비율 상태 뱃지
  Widget _buildDebtRatioBadge(double ratio) {
    Color color;
    String text;

    if (ratio < 100) {
      color = Colors.green;
      text = "안정적";
    } else if (ratio < 200) {
      color = Colors.orange;
      text = "보통";
    } else {
      color = Colors.red;
      text = "주의";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            "${ratio.toStringAsFixed(1)}% ",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.normal, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // 하단 범례 아이템
  Widget _buildLegendItem({
    required String title,
    required String value,
    required Color color,
    required CrossAxisAlignment align,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
