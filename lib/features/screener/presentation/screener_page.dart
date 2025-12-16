import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_chip_group.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_range_slider.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_section_header.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_slider.dart';

class ScreenerPage extends StatelessWidget {
  const ScreenerPage({super.key});

  static const double _pageH = 20;
  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '필터 설정'),
      backgroundColor: const Color(0xFFF6F7FB), // 화면 전체 배경을 아주 연하게
      body: ListView(
        padding: const EdgeInsets.fromLTRB(_pageH, 16, _pageH, 120), // 하단 버튼 여유
        children: [
          _SectionCard(
            title: '기본 정보',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterChipGroup(
                  title: '가격',
                  options: const [
                    '1천원 미만', '1천~5천원', '5천~1만원',
                    '1만~3만원', '3만~10만원', '10만원 이상'
                  ],
                  columns: 3, // 아래 (B)에서 추가
                  onSelected: (selected) {},
                ),
                const SizedBox(height: 20),
                FilterChipGroup(
                  title: '시가총액',
                  options: const ['대형주', '중형주', '소형주'],
                  columns: 3,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: '가치 · 재무',
            child: Column(
              children: [
                FilterSlider(
                  title: 'PER',
                  subtitle: '주가수익비율',
                  min: 0,
                  max: 50,
                  step: 1,
                  unit: '배',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: 'ROE',
                  subtitle: '자기자본이익률',
                  min: 0,
                  max: 30,
                  step: 1,
                  unit: '%',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '부채비율',
                  subtitle: '',
                  min: 0,
                  max: 300,
                  step: 10,
                  unit: '%',
                  onChanged: (value) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: '성장 · 수급',
            child: Column(
              children: [
                FilterRangeSlider(
                  title: '매출액 성장률',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  onChanged: (values) {},
                ),
                const SizedBox(height: 16),
                FilterSlider(
                  title: '순이익 성장률',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                FilterRangeSlider(
                  title: '외국인 보유율',
                  subtitle: '',
                  min: 0,
                  max: 100,
                  step: 5,
                  unit: '%',
                  onChanged: (values) {},
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: _BottomApplyBar(
        label: '검색하기',
        onPressed: () {},
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEFF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀 + (선택) 섹션 초기화 버튼 자리
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              // TextButton(onPressed: () {}, child: const Text('초기화')),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _BottomApplyBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BottomApplyBar({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, -6),
            color: Color(0x14000000),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
        ),
      ),
    );
  }
}
