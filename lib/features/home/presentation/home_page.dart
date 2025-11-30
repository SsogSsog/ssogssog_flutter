import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/features/home/presentation/widget/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        // SingleChildScrollView를 사용해 화면이 길어져도 스크롤 가능하게 함
        child: Column(
          children: [
            // 2. 메인 배너 (곧 만들 예정)
            // 3. 액션 블록 (곧 만들 예정)
            // 4. 내가 찜한 주식 배너 (곧 만들 예정)
            // 5. 팩트 체크 섹션 (곧 만들 예정)
          ],
        ),
      ),
    );
  }
}
