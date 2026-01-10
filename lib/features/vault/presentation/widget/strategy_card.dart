import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class StrategyCard extends StatelessWidget {
  const StrategyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin을 vertical 8로 주어 카드 간 간격 확보
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // 그림자 밝기
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4), // 아래쪽으로 그림자 내림
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // 내부 여백도 16 -> 20으로 살짝 늘림
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
                        fontWeight: FontWeight.w800, // 더 굵게
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    // 실행 로직
                    // TODO 필터(조건검사) 구현 후 해당 화면으로 이동시키기
                  },
                  child: Row(
                    children: [
                      Text(
                        '[ 실행 ',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 18,
                        color: Colors.grey[800],
                      ),
                      Text(
                        ' ]',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), // 간격 확보

            // 중단: 태그 리스트
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag('가격 1,000원 이하'),
                _buildTag('흑자전환'),
              ],
            ),

            const SizedBox(height: 16), // 간격 확보

            // 하단: 만족 종목 수
            const Text(
              '오늘 기준 만족 종목: 12개',
              style: TextStyle(
                color: AppColors.greyText,
                fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 좌우 여백 넉넉하게
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground, // 연한 파란 배경
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.primaryBlue, // 진한 파란 글씨
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}