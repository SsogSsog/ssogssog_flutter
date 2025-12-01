import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

class MyPicksBanner extends StatelessWidget {
  const MyPicksBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFEEEEEE), thickness: 6, height: 6),

        const SizedBox(height: 24), // 간격

        // 3. 버튼은 양옆 여백이 필요하므로, 버튼만 Padding으로 감싸기
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/home/folder.png',
                  width: 26,  // 아이콘 크기와 비슷하게 설정
                  height: 26,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Text(
                  '내가 찜한 주식 & 필터 확인하기',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32), // 하단 여백
      ],
    );
  }
}