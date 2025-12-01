import 'package:flutter/material.dart';
import 'package:ssogssog_flutter/core/theme/app_theme.dart';

/*
AppBottomNav: 하단 탭 UI를 담당
 */
class AppBottomNav extends StatelessWidget {
  // 하단 탭의 인덱스, 어떤 탭이 선택되어 있는지 (0 = 홈, 1 = 조건검색, 2 = 보관함, 3 = 설정)
  final int currentIndex;
  // 탭을 눌렀을 때 호출할 콜백 함수
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -5),
            blurRadius: 10,
          )
        ]
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        elevation: 5,

        iconSize: 30,

        // 아이콘 색상 설정
        selectedItemColor: AppColors.primaryBlue, // 선택 시 색상
        unselectedItemColor: AppColors.greyText,    // 미선택 시 색상

        // 라벨 숨기기
        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diamond),
            label: '조건검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: '보관함',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
