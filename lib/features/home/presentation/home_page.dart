import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/home_app_bar.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/main_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainBanner(), // 메인 배너 추가
            // 3. 액션 블록 (곧 만들 예정)
            // 4. 내가 찜한 주식 배너 (곧 만들 예정)
            // 5. 팩트 체크 섹션 (곧 만들 예정)
          ],
        ),
      ),
    );
  }
}
