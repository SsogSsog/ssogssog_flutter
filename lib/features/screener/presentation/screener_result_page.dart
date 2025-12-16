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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 현재 필터 보기 버튼
          _buildCurrentFilterButton(),

          // 2. 검색 결과 요약 텍스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '전일종가 기준으로 총 $resultCount건이 검색되었습니다.',
              style: const TextStyle(color: AppColors.greyText, fontSize: 13),
            ),
          ),

          // 3. 결과 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24), // 리스트 하단 여백
              itemCount: 10, // 임시로 10개 항목 표시
              itemBuilder: (context, index) {
                return const ScreenerResultCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  // '현재 필터 보기' 버튼 위젯
  Widget _buildCurrentFilterButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: 현재 필터 상세 보기 기능
        },
        icon: const Icon(Icons.filter_list, size: 20),
        label: const Text('현재 필터 보기'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), // 버튼의 최소 크기(너비, 높이)
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
