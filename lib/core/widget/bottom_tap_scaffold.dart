import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ssogssog_flutter/core/widget/app_bottom_nav.dart';

/*
BottomTapScaffold: 하단 네비게이션이 필요한 페이지들의 공통 레이아웃을 담당하는 위젯
 */
class BottomTapScaffold extends StatelessWidget {
  final Widget child; // 실제 페이지 내용

  const BottomTapScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  // 현재 경로(location)를 기반으로 BottomNav의 현재 인덱스를 계산하는 함수
  int _calculateCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/screener') {
      return 1;
    } else if (location == '/vault') {
      return 2;
    } else if (location == '/settings') {
      return 3;
    }
    return 0; // 기본값은 홈
  }

  // 하단 탭을 눌렀을 때 실행될 함수
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: // 홈
        context.go('/');
        break;
      case 1: // 조건검색
        context.go('/screener');
        break;
      case 2: // 보관함
        context.go('/vault');
        break;
      case 3: // 설정
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // 실제 페이지 내용 ex) HomeScreen
      // AppBottomNav에 현재 인덱스를 계산해서 넘겨주고, 탭 콜백을 연결
      bottomNavigationBar: AppBottomNav(
        currentIndex: _calculateCurrentIndex(context), // 현재 경로 기반 계산 값
        onTap: (index) => _onItemTapped(index, context), // 클릭 시 라우팅 로직
      ),
    );
  }
}
