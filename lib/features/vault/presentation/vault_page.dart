import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/widget/common_app_bar.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: '내 보관함'),
      body: Column(
        children: [
          // 2. '나의 전략' / '관심 종목' 탭 선택기 (곧 만들 예정)
          // 3. 전략 리스트 또는 관심 종목 리스트 (곧 만들 예정)
        ],
      ),
    );
  }
}
