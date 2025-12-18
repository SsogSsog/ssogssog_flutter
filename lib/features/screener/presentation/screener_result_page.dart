import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/screener_result_card.dart';

class ScreenerResultPage extends StatelessWidget {
  const ScreenerResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 필터링된 데이터를 받아서 처리해야 합니다.
    const int resultCount = 1731;

    return Scaffold(
      appBar: const CommonAppBar(title: '검색 결과'),
      backgroundColor: const Color(0xFFF6F7FB), // 배경색 추가
      body: Column(
        children: [
          _buildCurrentFilterHeader(resultCount),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, __) => ScreenerResultCard(),
            ),
          ),
        ],
      ),
    );
  }

  // '현재 필터 보기' 버튼 위젯
  Widget _buildCurrentFilterHeader(int resultCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // TODO: 현재 필터 bottom sheet
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDEFF5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18,
                        color: AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '현재 필터 보기',
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Icon(
                        Icons.chevron_right_rounded, color: Color(0xFF8B93A1)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '전일종가 기준으로 총 $resultCount건이 검색되었습니다.',
            style: const TextStyle(color: Color(0xFF8B93A1),
                fontSize: 12.5,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}


