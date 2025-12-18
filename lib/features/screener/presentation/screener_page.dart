import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_chip_group.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_range_slider.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/filter_slider.dart';

class ScreenerPage extends StatelessWidget {
  const ScreenerPage({super.key});

  static const double _pageH = 20;
  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '필터 설정'),
      backgroundColor: const Color(0xFFF6F7FB),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(_pageH, 16, _pageH, 120),
        children: [
          const _InfoBanner(
            text: '아래의 필터로 주식을 검색할 수 있습니다. 기준 값은 전일종가 기준으로 계산됩니다.',
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: '기본 정보',
            subtitle: '아무것도 선택하지 않으면 전체 종목을 대상으로 합니다.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterChipGroup(
                  title: '가격',
                  options: const [
                    '1천원 미만', '1천~5천원', '5천~1만원',
                    '1만~3만원', '3만~10만원', '10만원 이상'
                  ],
                  columns: 3,
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
        //  context.go -> context.push
        onPressed: () => context.push('/screener/result'), 
      ),
    );
  }
}


class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),

          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.3,
                color: Color(0xFF8B93A1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

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

class _InfoBanner extends StatelessWidget {
  final String text;

  const _InfoBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEFF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.tune, size: 18, color: Color(0xFF8B93A1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF2E3137),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
