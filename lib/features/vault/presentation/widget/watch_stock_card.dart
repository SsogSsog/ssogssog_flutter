import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class WatchStockCard extends StatelessWidget {
  final String stockName;
  final String stockCode;
  final String price;
  final String sector;
  // 등락률
  final String fluctuationRate;

  const WatchStockCard({
    super.key,
    required this.stockName,
    required this.stockCode,
    required this.price,
    required this.sector,
    required this.fluctuationRate,
  });

  @override
  Widget build(BuildContext context) {
    // 등락률이 '+'로 시작하면 상승(Red), 아니면 하락(Blue)으로 판단
    final bool isPlus = fluctuationRate.startsWith('+');
    final Color stateColor = isPlus ? const Color(0xFFFF6B6B) : const Color(0xFF4D96FF);
    final Color stateBgColor = isPlus ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // 위쪽 정렬
          children: [
            // [왼쪽] 종목 정보
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stockCode,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTag(sector),
              ],
            ),

            // [오른쪽] 가격 및 등락률
            Column(
              crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
              children: [
                // 1. 현재가
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6), // 가격과 등락률 사이 간격

                // 2. 등락률 배지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stateBgColor, // 연한 배경색
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    fluctuationRate,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: stateColor, // 진한 글자색
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}