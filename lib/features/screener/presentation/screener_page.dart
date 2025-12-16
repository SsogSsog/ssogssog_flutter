import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_chip_group.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_section_header.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_slider.dart';

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
            FilterChipGroup(
              title: '가격',
              options: const [
                '1천원 미만', '1천~5천원', '5천~1만원',
                '1만~3만원', '3만~10만원', '10만원 이상'
              ],
              onSelected: (selected) {},
            ),
            const SizedBox(height: 24),
            FilterChipGroup(
              title: '시가총액',
              options: const ['대형주', '중형주', '소형주'],
              onSelected: (selected) {},
            ),

            const FilterSectionHeader(title: '가치 & 건전성'),
            FilterSlider(
              title: 'PER',
              subtitle: '주가수익비율',
              min: 0,
              max: 100,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            FilterSlider(
              title: 'ROE',
              subtitle: '자기자본이익률',
              min: 0,
              max: 100,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            FilterSlider(
              title: '부채비율',
              subtitle: '',
              min: 0,
              max: 100,
              onChanged: (value) {},
            ),

            // TODO: '성장성 & 수급' 섹션이 여기에 들어옵니다.
          ],
        ),
      ),
    );
  }
}
