import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';

class ScreenerPage extends StatelessWidget {
  const ScreenerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 하단 탭 바는 부모인 AppScaffold에 의해 자동으로 추가됨
    return const Scaffold(
      appBar: CommonAppBar(title: '필터 설정'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 여기에 섹션 헤더, 칩 그룹, 슬라이더 위젯들이 들어옵니다.
            Text('필터링 UI'),
          ],
        ),
      ),
    );
  }
}
