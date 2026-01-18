import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class ScreenerResultCard extends StatelessWidget {
  final String name;
  final String code;
  final int price;
  final double changeRate;
  final int volume;

  const ScreenerResultCard({
    super.key,
    required this.name,
    required this.code,
    required this.price,
    required this.changeRate,
    required this.volume,
  });

  String _fmtInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isUp = changeRate >= 0;
    final rateColor = isUp ? const Color(0xFFE53935) : const Color(0xFF1565C0);
    final rateText = '${isUp ? '+' : ''}${changeRate.toStringAsFixed(2)}%';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // [핵심 수정] 탭하면 종목 코드를 가지고 상세 페이지로 이동
          context.push('/stock/$code');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEDEFF5)),
          ),
          child: Row(
            children: [
              // 좌측: 종목 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111318),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8B93A1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // 우측: 가격/등락/거래량
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_fmtInt(price)}원',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111318),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rateText,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: rateColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF8B93A1)),
                      const SizedBox(width: 4),
                      Text(
                        '거래량 ${_fmtInt(volume)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B93A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
