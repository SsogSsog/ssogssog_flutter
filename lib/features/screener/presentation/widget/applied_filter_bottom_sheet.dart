import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/// '적용된 필터'의 상세 내용을 보여주는 바텀 시트 위젯
class AppliedFilterBottomSheet extends StatelessWidget {
  const AppliedFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 적용된 필터 목록을 외부에서 받아와야 합니다.
    final List<String> appliedFilters = [
      '1만~3만원', '중형주', 'PER 0~10배', 'ROE 전체',
      '부채비율 0~200%', '매출액 성장률 10~100%', '순이익 성장률 전체',
      '외국인 보유율 30~70%'
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 콘텐츠 크기만큼만 높이 차지
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 제목과 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('적용된 필터', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Navigator.pop(context), // 바텀 시트 닫기
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('현재 조건을 저장해 빠르게 불러올 수 있습니다.', style: TextStyle(color: AppColors.greyText)),
          const SizedBox(height: 24),

          // 2. 적용된 필터 칩 목록
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: appliedFilters.map((filter) => _buildFilterChip(filter)).toList(),
          ),
          const SizedBox(height: 32),

          // 3. 하단 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // 바텀 시트 닫고
                    context.go('/screener'); // 필터 설정 페이지로 이동
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Text('필터 수정'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 이 조건 저장 기능
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('이 조건 저장'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 필터 칩을 만드는 위젯
  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(color: AppColors.greyText, fontWeight: FontWeight.w500)),
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: () {
        // TODO: 개별 필터 삭제 로직
      },
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
