import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_chip_group.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_section_header.dart';

class ScreenerPage extends StatelessWidget {
  const ScreenerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '필터 설정'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterSectionHeader(title: '기본 정보'),

            // '가격' 필터
            FilterChipGroup(
              title: '가격',
              options: const [
                '1천원 미만', '1천~5천원', '5천~1만원',
                '1만~3만원', '3만~10만원', '10만원 이상'
              ],
              onSelected: (selected) {
                // TODO: 선택된 가격 처리 로직
              },
            ),
            const SizedBox(height: 24), // 필터 간 간격

            // '시가총액' 필터
            FilterChipGroup(
              title: '시가총액',
              options: const ['대형주', '중형주', '소형주'],
              onSelected: (selected) {
                // TODO: 선택된 시가총액 처리 로직
              },
            ),

            // TODO: 다음 섹션 '가치 & 건전성'
          ],
        ),
      ),
    );
  }
}
