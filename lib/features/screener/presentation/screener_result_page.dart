import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';

class ScreenerResultPage extends StatelessWidget {
  const ScreenerResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 필터링된 데이터를 받아서 처리하기
    const int resultCount = 1731;

    return const Scaffold(
      appBar: CommonAppBar(title: '검색 결과'),
      body: Column(
        children: [
          // TODO: 1. 현재 필터 보기 버튼
          // TODO: 2. 검색 결과 요약 텍스트
          // TODO: 3. 결과 리스트
          Center(
            child: Text('검색 결과가 여기에 표시됩니다.'),
          )
        ],
      ),
    );
  }
}
