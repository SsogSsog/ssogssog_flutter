import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class ScreenerResultCard extends StatelessWidget {
  ScreenerResultCard({super.key});

  // 임시 데이터 (나중에 모델로 주입)
  final String name = '큐로홀딩스';
  final String code = '051780';
  final int price = 1236;
  final double changeRate = 29.97; // +면 상승, -면 하락
  final int volume = 2517785;

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
          // TODO: 종목 상세
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
                        fontWeight: FontWeight.w800, // w900 -> w800
                        color: Color(0xFF111318),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8B93A1),
                        fontWeight: FontWeight.w600, // w700 -> w600 (살짝 부드럽게)
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
                      fontWeight: FontWeight.w800, // w900 -> w800
                      color: Color(0xFF111318),
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    rateText,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: rateColor,
                      fontWeight: FontWeight.w800, // w900 -> w800
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
                          fontWeight: FontWeight.w600, // w700 -> w600
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star_border_rounded, color: Color(0xFF8B93A1)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                splashRadius: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}