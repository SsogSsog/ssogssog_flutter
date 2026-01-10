import 'package:flutter/material.dart';

// implements PreferredSizeWidget 사용 시 Scaffold에 들어가는 위젯은 크기를 알고 있어야 한다.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  // 원하는 앱바 높이 한 번에 관리
  static const double _appBarHeight = 96;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // AppBar의 배경색을 페이지 배경색과 맞춤
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,

      toolbarHeight: _appBarHeight,
      centerTitle: false,
      titleSpacing: 16,

      title: Image.asset(
        'assets/images/logo/ssogssog_logo.png',
        height: 80,
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black, size: 28),
          onPressed: () {
            // TODO: 검색 페이지로 이동
          },
        ),
      ],
    );
  }

  // PreferredSizeWidget을 구현하면 반드시 이 getter를 구현해야 한다.
  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight); //kToolbarHeight: flutter에서 재공한 기본 툴바 높이
}
