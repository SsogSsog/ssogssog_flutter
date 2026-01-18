import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class StrategyCard extends StatelessWidget {
  const StrategyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin을 vertical 8로 주어 카드 간 간격 확보
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), // 10 -> 6
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14), // 16 -> 14
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 0.15 -> 0.08
            spreadRadius: 0,
            blurRadius: 8, // 10 -> 8
            offset: const Offset(0, 2), // 4 -> 2
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 20 -> 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 폴더 아이콘 + 제목 + 실행 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽: 아이콘 + 제목
                Row(
                  children: [
                    Image.asset(
                      'assets/images/home/folder.png',
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '전략 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w700, // w800 -> w700
                        fontSize: 16, // 18 -> 16
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    // 실행 로직
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '실행',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12), // 16 -> 12

            // 중단: 태그 리스트
            Wrap(
              spacing: 6, // 8 -> 6
              runSpacing: 6,
              children: [
                _buildTag('가격 1,000원 이하'),
                _buildTag('흑자전환'),
              ],
            ),

            const SizedBox(height: 12), // 16 -> 12

            // 하단: 만족 종목 수
            const Text(
              '오늘 기준 만족 종목: 12개',
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 13, // 14 -> 13
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // 12/6 -> 10/5
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground, // 연한 파란 배경
        borderRadius: BorderRadius.circular(6), // 8 -> 6
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12, // 13 -> 12
          color: AppColors.primaryBlue, // 진한 파란 글씨
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}