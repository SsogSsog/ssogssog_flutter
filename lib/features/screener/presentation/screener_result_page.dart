import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/applied_filter_bottom_sheet.dart';
import 'package:ssogssog_flutter/features/screener/presentation/widget/screener_result_card.dart';

class ScreenerResultPage extends StatelessWidget {
  const ScreenerResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int resultCount = 1731;

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          _buildCurrentFilterHeader(context, resultCount),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              // [핵심 수정] ScreenerResultCard에 임시 데이터를 전달하여 오류 해결
              itemBuilder: (_, __) => const ScreenerResultCard(
                name: '큐로홀딩스',
                code: '051780',
                price: 1236,
                changeRate: -29.97,
                volume: 2517785,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFilterHeader(BuildContext context, int resultCount) {
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => const AppliedFilterBottomSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEDEFF5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '현재 필터 보기',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF8B93A1)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '전일종가 기준으로 총 $resultCount건이 검색되었습니다.',
            style: const TextStyle(color: Color(0xFF8B93A1), fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
