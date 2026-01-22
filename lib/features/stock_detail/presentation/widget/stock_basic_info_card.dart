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
        border: Border.all(color: const Color(0xFFE0E0E0)),
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

  // 52주 최저/최고 바 위젯 (CustomPainter 사용)
  Widget _build52WeekRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [핵심 추가] 소제목 추가
        Text(
          '52주 최고/최저', 
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('52주 최저', style: TextStyle(color: Colors.blue[600], fontSize: 12)),
            const Text('52주 최고', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, 30), // 높이 확보
              painter: _RangePainter(
                current: data.currentPrice.toDouble(),
                min: data.week52Low.toDouble(),
                max: data.week52High.toDouble(),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatPrice(data.week52Low), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[600])),
            Text(_formatPrice(data.week52High), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    // 3자리마다 콤마 찍기
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
        final posFromEnd = s.length - i;
        buf.write(s[i]);
        if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class _RangePainter extends CustomPainter {
  final double current;
  final double min;
  final double max;

  _RangePainter({required this.current, required this.min, required this.max});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double barY = size.height - 4; 
    
    // 1. 회색 배경 바
    final Paint barPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawLine(
      Offset(0, barY), 
      Offset(w, barY), 
      barPaint
    );

    // 2. 현재 위치 계산
    final range = max - min;
    double t = 0.5;
    if (range > 0) {
      t = ((current - min) / range).clamp(0.0, 1.0);
    }
    final double cx = w * t;

    // 3. 삼각형 마커 (Black -> Primary Color/Accent)
    // "현재가 부분만이라도 색깔을 다르게 하거나"
    // Let's use a distinct color. Black is classic but user said "monotone".
    // Maybe use a generic dark color or the primary App color? 
    // Let's stick to Black but make the text emphasized or maybe use a dark blue?
    // Actually, Black is the clearest contrast. Let's keep Black marker but ensure text is clear.
    // Or maybe use the specific Red/Blue depending on if it's high/low? No, that's confusing.
    // Let's try a deep indigo or just keep Black but maybe add a small circle indicator on the bar?
    // User asked for "^" (Caret).
    // Let's keep the Black caret but maybe add a colored dot closer to the bar? 
    // "그래프 색깔이 전부 회색이여서 단조로워" -> The BG bar is grey.
    // Let's make the "Current Price" text color same as the generic text color (Black) but Bold.
    // User complained about "all grey".
    // I will color the *active* part? No, they said "not filling".
    // Using Black for the marker is fine if the labels below are colored Blue/Red (which I did in this Step).
    // That adds color.
    
    final Paint markerPaint = Paint()..color = const Color(0xFF222222); // Dark Grey/Black
    final Path triPath = Path();
    final double triBaseY = barY - 3;
    
    triPath.moveTo(cx, triBaseY - 5); 
    triPath.lineTo(cx - 4, triBaseY); 
    triPath.lineTo(cx + 4, triBaseY); 
    triPath.close();
    
    canvas.drawPath(triPath, markerPaint);

    // 4. '현재가' 텍스트
    final textStyle = TextStyle(
      color: const Color(0xFF222222),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    
    final textSpan = TextSpan(text: '현재가', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    final textX = cx - textPainter.width / 2;
    final textY = triBaseY - 5 - textPainter.height - 3; 
    
    double safeTextX = textX.clamp(0.0, w - textPainter.width);
    
    textPainter.paint(canvas, Offset(safeTextX, textY));
  }

  @override
  bool shouldRepaint(covariant _RangePainter oldDelegate) {
     return oldDelegate.current != current || 
            oldDelegate.min != min || 
            oldDelegate.max != max;
  }
}
